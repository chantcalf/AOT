function ta = ScaleRevise(I,target)
[maxX,maxY,dd] = size(I);
ta = target;
context = [target(1)-(target(3)-1)/2,target(2)-(target(4)-1)/2,target(3)*2,target(4)*2];
context = round(context);
if context(1)<1 context(1)=1;end
if context(2)<1 context(2)=1;end
if context(1)+context(3)-1>maxX context(3)=maxX-context(1)+1;end
if context(2)+context(4)-1>maxY context(4)=maxY-context(2)+1;end

s0 = checkT(I,context)
s1 = checkT(I,target)
%if s0*2 > s1, return;end

p = imgcrop(I,context);
p(p<0.5) = 0;
p(p>=0.5) = 1;

B = [0 1 0;1 1 1;0 1 0];
p = imerode(p,B);
%subplot(141);imshow(p);
p=medfilt2(p,[3,3]);

%subplot(142);imshow(p);
%p(p<0.5) = 0;
%p(p>=0.5) = 1;
%H = fspecial('gaussian');
%p = filter2(H,p);
%p(p<0.5) = 0;
%p(p>=0.5) = 1;




%p1 = imerode(p,B);
p = imdilate(p,B);
%subplot(143);imshow(p);
p(p<0.5) = 0;
p(p>=0.5) = 1;
%subplot(144);imshow(p);
x = sum(p);
y = sum(p,2);
ta = [1,1,context(3),context(4)];
ss = 4;
while (ta(1)<ta(3) && x(ta(1))<ss)
    ta(1) = ta(1)+1;
end

while (ta(1)<ta(3) && x(ta(3))<ss)
    ta(3) = ta(3)-1;
end

while (ta(2)<ta(4) && y(ta(2))<ss)
    ta(2) = ta(2)+1;
end

while (ta(2)<ta(4) && y(ta(4))<ss)
    ta(4) = ta(4)-1;
end
ta(3:4) = ta(3:4) - ta(1:2)+1;
ta(1:2) = ta(1:2) + context(1:2);

%subplot(144);imshow(imgcrop(I,ta));
%pause(0.1);