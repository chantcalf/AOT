function rec = selectAOs_F(I0,I,target,param,N)
[maxY,maxX,kk] = size(I);
I1 = I-I0;
if (kk==3) I1=rgb2gray(I1);end
I1 = double(abs(I1))/255;
%subplot(221);imshow(I1);title('1');
%C = getContext(I,target,3);
D = round((target + [1,1,maxX,maxY])/2);
I2 = abs(imgcrop(I1,D));
I2 = medfilt2(I2,[3,3]);
H = fspecial('gaussian');
I2 = filter2(H,I2);
%subplot(222);imshow(I2);title('2');
I2(I2>=0.1) = 1;
I2(I2<0.1) = 0;
B = [1 1 1;1 1 1;1 1 1];
I2 = imdilate(I2,B);
%subplot(223);imshow(I2);title('3');
p = I2;

[L,num] = bwlabel(p,8);

stats = regionprops(L,'Area');
stats1 = regionprops(L,'BoundingBox');  

area = cat(1,stats.Area);
srec = cat(1,stats1.BoundingBox);
n = 0;
%subplot(224);
%imshow(imgcrop(I,D));
%imshow(p);
%title('4');
%hold on;
rec = [];
for i=1:num
    id = find(area == max(area));
    R = srec(id(1),:);
    if (R(3)*R(4)<1000)
        if (R(3)<15)
            R(1)=R(1)+R(3)/2-8;
            R(3)=15;
        end
        if (R(4)<15)
            R(2)=R(2)+R(4)/2-8;
            R(4)=15;
        end
        n = n+1;
        rec(n,:) = round(R);
        %{
        x0=R(1);
        y0=R(2);
        ww=R(3);
        h=R(4);
        plot([x0,x0+ww,x0+ww,x0,x0],...
        [y0,y0,y0+h,y0+h,y0],'-y','LineWidth',4);
        %}
        
        if (n == N) break;end
    end
    area(id) = 0;
end
if (n>0)
    rec(:,1:2) = rec(:,1:2)+ones(n,1)*D(1:2);
end
%{
imshow(I);hold on;

for i=1:n
    x0=rec(i,1);
    y0=rec(i,2);
    ww=rec(i,3);
    h=rec(i,4);
    plot([x0,x0+ww,x0+ww,x0,x0],...
    [y0,y0,y0+h,y0+h,y0],'-y','LineWidth',4);
end
%}