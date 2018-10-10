function results=run_AOT(seq, res_path, bSaveImage)

%close all
%rng('default')
rng('shuffle');
s_frames = seq.s_frames;
param=paraConfig_PF1();
[I] = loadFrame(s_frames{1},param.DS);
[maxY,maxX,dummy] = size(I);
target=seq.init_rect;
w = ones(param.numOfParticles,1)/param.numOfParticles;
[particles,w] = predictParticles(ones(param.numOfParticles,1)*target,w,param,maxX,maxY);
targetRec(1,:) = target;  
para.minsize = target(3);
para.maxsize = target(4);
if target(4) < para.minsize
    para.minsize = target(4);
    para.maxsize = target(3);
end

targetold = target;

[targetH,s0] = BC(I,target,param.hk);
targetH1 = targetH;
targetH1(targetH1>=s0) = 1;
targetH1(targetH1<s0) = 0.1;

II = TBC(I,targetH,param.hk);

s1 = checkT(II,target);

h = hist(I,target,param.hk);

%{

h = h.*targetH1;
h = h/sum(h,2);
%}
h0 = h;



[AOs_rec,AOs_x,AOs_v,AOs_h,AOs_w,AOs_c] = selectAOs(I,II,target,param,param.numOfAOs);
AOsshow(I,target,AOs_rec,1,[0,0]);

duration = 0;
dmin =1;
pdang = 0;
pdx = 0;
for f = 2:seq.len
    f
    
    [I] = loadFrame(s_frames{f},param.DS);  
    %TBC(I,targetH,param.hk);

    tic  
    
    II = TBC(I,targetH,param.hk);
    
    for p = 1:size(particles,1)
        h1 = hist(I,particles(p,:),param.hk);
        
        dd = BD(h1,h);
        w(p) = weight(dd);
    end    
    sw = sum(w);
    w = w/sw;
    
    target = updateTargetState(target,particles,w,param,maxX,maxY)

    %h=h*(1-param.MAalpha)+hist1(imgcrop(I,target),param.hk)*param.MAalpha;
    hh=hist(I,target,param.hk);
    dd = BD(hh,h);
    pdx =0;
    if (pdang==1 && dd>=dmin*0.5)
        dx = [target(1)+target(3)/2-targetold(1)-targetold(3)/2,target(2)+target(4)/2-targetold(2)-targetold(4)/2];
        if (dx(1)^2+dx(2)^2<=targetold(3)^2+targetold(4)^2+100)
            pdang = 0;
            pdx = 1;
        end
    end
        
            
    if (f<=5)
        if dd<dmin dmin=dd;end
    end
    if f==5
        dmin
    end
    if (f>5 && dd<dmin*0.5) pdang=1;end
    pdang
    As = zeros(size(AOs_rec,1),1);
    for i = 1:size(AOs_rec,1)
        [AOs_rec(i,:),As(i)]=meanshift(I,AOs_rec(i,:),AOs_h(i,:),param.hk);
    end
    [AOs_rec,AOs_x,AOs_v,AOs_h,AOs_w,AOs_c] = checkAO(AOs_rec,AOs_x,AOs_v,AOs_h,AOs_w,AOs_c,As,maxX,maxY);
    %[AOs_x,AOs_y] = predictAOs(AOs_rec,AOs_x,AOs_y,AOs_t,pdang);
    %[target1,cof1,param.ro] = calAOs(AOs_rec,AOs_w,AOs_x,AOs_v,AOs_c,param.ro,targetold,param.ro1,pdang);
    [target1,cof1] = calAOs2(I,AOs_rec,AOs_w,AOs_x,AOs_v,AOs_c,pdang);
    target1
    %outshow(I,target,f);
    ta1 = [target1(1)-targetold(3)/2+0.5,target1(2)-targetold(4)/2+0.5,targetold(3),targetold(4)];
    ta1 = round(ta1);
    
    if f>5 && target1(1)>0
        
        %ht1 = hist(I,ta1,param.hk);
        %dd1 = BD(h0,ht1);
        %dd = BD(h0,hh);
        dc1 = checkT(II,target);
        dc2 = checkT(II,ta1);
        if pdang==0
            %xx0=target(1)+target(3)/2-0.5;
            %yy0=target(2)+target(4)/2-0.5;
            k=dc2*cof1;
            k=k/(k+dc1)
            target = round(target*(1-k)+ta1*k);

        else
            target = targetold
            if cof1>0.3
                target = ta1; 
            end
        end
    end
    
    hh=hist(I,target,param.hk);
    %{
    hh = hh.*targetH1;
    hh = hh/sum(sum(h,2));
    %}
    dd = BD(hh,h);
    if (mod(f,5)==0 && pdang==0)
        h=h*(1-param.MAalpha)+hh*param.MAalpha;
    end
    
    dc = checkT(II,target)
    if (pdang==0 && dc<s1*0.6)
        h = h0;
    end
    if (pdang==1)
        h = h0;
    end
    
    [particles w] = updateParticles(target,particles,w,maxX,maxY,param,pdang);
    
    [AOs_rec,AOs_x,AOs_v,AOs_h,AOs_w,AOs_c] = updateAO(I,II,AOs_rec,AOs_x,AOs_v,AOs_h,AOs_w,AOs_c,target,param,pdang,pdx);
    
    duration = duration+toc;
    
    targetRec(f,:) = target;
    targetold = target
    
    AOsshow(I,target,AOs_rec,f,ta1); 

    %outshow(II,target,f);
    
end 


results.type='rect';
results.res=targetRec;

results.fps=(seq.len-1)/duration;

disp(['fps: ' num2str(results.fps)])


function w=weight(d)
sg2=0.02;
w=exp(-(1-d)/sg2);

function lb=resample(w,n)
[ww,pos]=sort(w,'descend');
for i=2:n
    ww(i)=ww(i-1)+ww(i);
end
for i=1:n
    t=rand();
    b=find(ww,t);
    lb(i,1)=pos(b);
end

function b=find(w,t)
b=1;
n=size(w);
for i=2:n
    if (t<=w(i))
        b=i;
        break;
    end
end

function outshow(I,target,f)
%subplot(121);

imshow(I);title(num2str(f));hold on;
x0=target(1);
y0=target(2);
ww=target(3);
h=target(4);
plot([x0,x0+ww,x0+ww,x0,x0],...
    [y0,y0,y0+h,y0+h,y0],'-r','LineWidth',4);
pause(0.1);
hold off;

function AOsshow(I,target,AOs,f,target1)
%subplot(122);
imshow(I);title(num2str(f));hold on;

x0=target(1);
y0=target(2);
ww=target(3);
h=target(4);
plot([x0,x0+ww,x0+ww,x0,x0],...
    [y0,y0,y0+h,y0+h,y0],'-r','LineWidth',4);

if (target1(1)>0)
    x0=target1(1);
    y0=target1(2);
    ww=target1(3);
    h=target1(4);
    plot([x0,x0+ww,x0+ww,x0,x0],...
    [y0,y0,y0+h,y0+h,y0],'-b','LineWidth',4);
end
%{
 if (target1(1)>0)
    x0=round(target1(1)-15);
    y0=round(target1(2)-15);
    plot([x0,x0+30,x0+30,x0,x0],...
        [y0,y0,y0+30,y0+30,y0],'-r','LineWidth',4);
end
%}


m=size(AOs,1);
for i=1:0
    x0=AOs(i,1);
    y0=AOs(i,2);
    ww=AOs(i,3);
    h=AOs(i,4);
    plot([x0,x0+ww,x0+ww,x0,x0],...
        [y0,y0,y0+h,y0+h,y0],'-g','LineWidth',4);
end

pause(0.1);
hold off;

