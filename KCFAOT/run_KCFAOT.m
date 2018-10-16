function results=run_AOTtest(seq, res_path, bSaveImage)
close all

feature_type = 'hog';
kernel_type = 'gaussian';
kernel.type = kernel_type;
	
features.gray = false;
features.hog = false;

padding = 1.5;  %extra area surrounding the target
lambda = 1e-4;  %regularization
output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)


switch feature_type
	case 'gray',
		interp_factor = 0.075;  %linear interpolation factor for adaptation

		kernel.sigma = 0.2;  %gaussian kernel bandwidth
		
		kernel.poly_a = 1;  %polynomial kernel additive term
		kernel.poly_b = 7;  %polynomial kernel exponent
	
		features.gray = true;
		cell_size = 1;
		
	case 'hog',
		interp_factor = 0.02;
		
		kernel.sigma = 0.5;
		
		kernel.poly_a = 1;
		kernel.poly_b = 9;
		
		features.hog = true;
		features.hog_orientations = 9;
		cell_size = 4;
    otherwise
    error('Unknown feature.')
end

show_visualization = false;


video_path = '';
img_files = seq.s_frames;
target_sz = [seq.init_rect(1,4), seq.init_rect(1,3)];
pos = [seq.init_rect(1,2), seq.init_rect(1,1)] + floor(target_sz/2);

resize_image = (sqrt(prod(target_sz)) >= 100);  %diagonal size >= threshold
	if resize_image,
		pos = floor(pos / 2);
		target_sz = floor(target_sz / 2);
    end
    
    
addpath('./AO');
param = paraConfig_AO;
s_frames = seq.s_frames;
I = imread(s_frames{1});
target = seq.init_rect;
if resize_image,
    I = imresize(I, 0.5);
    target = floor(target/2);
end

AOs = [];

[targetH,s,tHD] = BC(I,target,param.hk,AOs);
s
tH = targetH;
II1 = pr(I,target);  
II = TBC(I,tH,param.hk);
s0 = checkT(II,target)
context = getContext(II,target,2);
ssc0 = sum(sum(imgcrop(II,context),2))/target(3)/target(4) - s;
sx0 = ssc0/s;

[maxY,maxX,dummy] = size(I);

%{
param.dmin = target(3);
if target(4)<target(3)
    param.dmin = target(4);
end

param.dmin = floor(param.dmin/4)^2;

param.dmax = 4*param.dmin
%}


ta1 = [0,0,0,0];
ta2 = [0,0,0,0];
B = 0;
C = 0;

	%window size, taking padding into account
	window_sz = floor(target_sz * (1 + padding));
	
% 	%we could choose a size that is a power of two, for better FFT
% 	%performance. in practice it is slower, due to the larger window size.
% 	window_sz = 2 .^ nextpow2(window_sz);

	
	%create regression labels, gaussian shaped, with a bandwidth
	%proportional to target size
	output_sigma = sqrt(prod(target_sz)) * output_sigma_factor / cell_size;
	yf = fft2(gaussian_shaped_labels(output_sigma, floor(window_sz / cell_size)));

	%store pre-computed cosine window
	cos_window = hann(size(yf,1)) * hann(size(yf,2))';	
	
	
	if show_visualization,  %create video interface
		update_visualization = show_video(img_files, video_path, resize_image);
	end
	
	
	%note: variables ending with 'f' are in the Fourier domain.

	time = 0;  %to calculate FPS
	positions = zeros(numel(img_files), 2);  %to calculate precision

	%for frame = 1:numel(img_files),
    for frame = 1:numel(img_files),
        frame
		%load image
		im = imread([video_path img_files{frame}]);
        I0 = I;
        I = im;
		if size(im,3) > 1,
			im = rgb2gray(im);
		end
		if resize_image,
			im = imresize(im, 0.5);
            I = imresize(I, 0.5);
        end
        ta1 = target;
        II = TBC(I,tH.*tHD,param.hk);
        II1 = pr(I,target);  
         
        
        %II0 = TBC(I,tH0,param.hk);

		tic()

		if frame > 1,
			%obtain a subwindow for detection at the position from last
			%frame, and convert to Fourier domain (its size is unchanged)
			patch = get_subwindow(im, pos, window_sz);
			zf = fft2(get_features(patch, features, cell_size, cos_window));
			
			%calculate response of the classifier at all shifts
			switch kernel.type
			case 'gaussian',
				kzf = gaussian_correlation(zf, model_xf, kernel.sigma);
			case 'polynomial',
				kzf = polynomial_correlation(zf, model_xf, kernel.poly_a, kernel.poly_b);
			case 'linear',
				kzf = linear_correlation(zf, model_xf);
			end
			response = real(ifft2(model_alphaf .* kzf));  %equation for fast detection
            
			%target location is at the maximum response. we must take into
			%account the fact that, if the target doesn't move, the peak
			%will appear at the top-left corner, not at the center (this is
			%discussed in the paper). the responses wrap around cyclically.
			[vert_delta, horiz_delta] = find(response == max(response(:)), 1);
			if vert_delta > size(zf,1) / 2,  %wrap around to negative half-space of vertical axis
				vert_delta = vert_delta - size(zf,1);
			end
			if horiz_delta > size(zf,2) / 2,  %same for horizontal axis
				horiz_delta = horiz_delta - size(zf,2);
			end
			pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
            rect = [pos-floor(target_sz/2),target_sz];
            target = [rect(2),rect(1),rect(4),rect(3)];
            ta2 = target;
            
            m = size(AOs,1);
            
            if (m>0)
                for i = 1:m
                    [AOs(i).rec,AOs(i).s]=meanshift(I,AOs(i).rec,AOs(i).h,param.hk);
                end
                AOs = checkAO(AOs,maxX,maxY);
            
                target1 = calAOs2(I,AOs);
                if (target1(1)>0 && target1(2)>0)
                    
                    ta1 = [target1(1)-target(3)/2+0.5,target1(2)-target(4)/2+0.5,target(3),target(4)];
                    ta1 = round(ta1);
                    ta1 = correct(ta1,maxX,maxY);
                    target = correct(target,maxX,maxY);
                    %B = isBackgroundClutter(II,ta1,sx0,s)
                    target = fusing(II,II1,target,ta1,param.dmin,param.dmax,B); 
                end
            end

            AOs = updateAO(I0,I,AOs,target,param);
            %[targetH,s] = BC(I,target,param.hk);
            %II1 = TBC(I,tH,param.hk);
            
            %B = isBackgroundClutter(II,target,sx0,s)
            su0 = checkT(II*0.5+II1*0.5,target)
            
            [targetH,ssu,tHD1] = BC(I,target,param.hk,AOs);
            ssu
            B=0;
            if ssu<0.5
                B=1;
            end
            B
            tH = tH*0.9 + targetH*0.1;
            tHD = tHD*0.9 + tHD1*0.1;

            pos = [target(2),target(1)]+floor([target(4),target(3)]/2);
                     
        end
        %{
        if frame==10
            return;
        end
        %}
		%obtain a subwindow for training at newly estimated target position
		patch = get_subwindow(im, pos, window_sz);
		xf = fft2(get_features(patch, features, cell_size, cos_window));

		%Kernel Ridge Regression, calculate alphas (in Fourier domain)
		switch kernel.type
		case 'gaussian',
			kf = gaussian_correlation(xf, xf, kernel.sigma);
		case 'polynomial',
			kf = polynomial_correlation(xf, xf, kernel.poly_a, kernel.poly_b);
		case 'linear',
			kf = linear_correlation(xf, xf);
		end
		alphaf = yf ./ (kf + lambda);   %equation for fast training

		if frame == 1,  %first frame, train with a single image
			model_alphaf = alphaf;
			model_xf = xf;
		else
			%subsequent frames, interpolate model
			model_alphaf = (1 - interp_factor) * model_alphaf + interp_factor * alphaf;
			model_xf = (1 - interp_factor) * model_xf + interp_factor * xf;
        end    
        

		%save position and timing
		
		time = time + toc();
        
        positions(frame,:) = pos;
        res(frame,:) = target;
        %{
        subplot(231);imshow(II);
        subplot(232);imshow(II1);
        subplot(233);imshow(II.*II1);
        %}
        
        %AOsshow(I,target,AOs,frame,ta1,ta2)
        
        subplot(121);
        AOsshow(II.*II1,target,AOs,frame,ta1,ta2)
        subplot(122);
        AOsshow(I,target,AOs,frame,ta1,ta2)
        %}
		%visualization
		if show_visualization,
			box = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
			stop = update_visualization(frame, box);
			if stop, break, end  %user pressed Esc, stop early
			
			drawnow
% 			pause(0.05)  %uncomment to run slower
		end
		
	end

	if resize_image,
		positions = positions * 2;
        res = res * 2;
	end

%{
ppt = 'C:\Users\Administrator\Desktop\labtest\';
save([ppt,seq.name,'_ta1res.mat'],'ta1res');
save([ppt,seq.name,'_ta2res.mat'],'ta2res');
save([ppt,seq.name,'_AOs.mat'],'AOsres');
%}

fps = numel(img_files) / time;

disp(['fps: ' num2str(fps)])

results.type = 'rect';
results.res = res;%each row is a rectangle
results.fps = fps;

%show the precisions plot
% show_precision(positions, ground_truth, video_path)

