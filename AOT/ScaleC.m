function tx = ScaleC(I,rec,rec0,s)
x0 = rec(1)+rec(3)/2-0.5;
y0 = rec(2)+rec(4)/2-0.5;
w = rec(3);
if (w<rec0(3)) w= rec0(3);end
h = rec(4);
if (h<rec0(4)) h= rec0(4);end
w = w*0.6;
h = h*0.6;
[m,n] = size(I);

d = round([x0-w,y0-h,w*2+1,h*2+1]);
if d(1)<1 d(1)=1;end
if d(2)<1 d(2)=1;end
if d(1)+d(3)-1>n d(3)=n-d(1);end
if d(2)+d(4)-1>m d(4)=m-d(2);end
x0 = x0-d(1)+1;
y0 = y0-d(2)+1;
p = imgcrop(I,d);
p(p<s)=0;
p(p>=s)=1;
%subplot(131);imshow(p);

B = [0 1 0;1 1 1;0 1 0];
p1 = imdilate(p,B);
p2 = imerode(p1,B);

%subplot(132);imshow(p2);


tx = [1,1,d(3),d(4)];
while (tx(1)+1<tx(3) && sum(p2(:,tx(1)))<10)
    tx(1)=tx(1)+1;
end
while (tx(1)+1<tx(3) && sum(p2(:,tx(3)))<10)
    tx(3)=tx(3)-1;
end
while (tx(2)+1<tx(4) && sum(p2(tx(2),:),2)<10)
    tx(2)=tx(2)+1;
end
while (tx(2)+1<tx(4) && sum(p2(tx(4),:),2)<10)
    tx(4)=tx(4)-1;
end

tx(3)=tx(3)-tx(1)+1;
tx(4)=tx(4)-tx(2)+1;
tx(1)=tx(1)+d(1)-1;
tx(2)=tx(2)+d(2)-1;
%subplot(133);imshow(imgcrop(I,tx));
%pause(0.1);


