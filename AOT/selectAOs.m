function [rec,x,v,h,w,c] = selectAOs(I,II,target,param,N)
[maxY,maxX,dummy] = size(I);

d = [target(1)+(target(3)-1)/2,target(2)+(target(4)-1)/2,target(3)*2,target(4)*2];
wh = param.sizeOfAOs;
rec = [randn(N,1)*d(3)+d(1), randn(N,1)*d(4)+d(2), randn(N,1)*5+wh , randn(N,1)*5+wh];
rec(:,1)=rec(:,1)-(rec(:,3)-1)/2;
rec(:,2)=rec(:,2)-(rec(:,4)-1)/2;
rec=round(rec);

i1 = rec(:,1) < 1;
i2 = rec(:,2) < 1;
i3 = rec(:,1)+rec(:,3)-1 > maxX;
i4 = rec(:,2)+rec(:,4)-1 > maxY;
i = i1+i2+i3+i4;
rec(i>0,:) = [];

m = size(rec,1);
lb = zeros(m,1);
for i = 1:m
    s = checkT(II,rec(i,:));
    if s<0.4
        lb(i,1) = 1;
    end
end
rec(lb>0,:) = [];


m = size(rec,1);
x = zeros(m,2);
v = zeros(m,2);
c = zeros(m,1);

x(:,1) = target(1)-rec(:,1)+(target(3)-rec(:,3))/2;
x(:,2) = target(2)-rec(:,2)+(target(4)-rec(:,4))/2;

h = [];
for i = 1:m
    I1 = imgcrop(I,rec(i,1:4));
    h(i,:) = hist1(I1,param.hk);
end

w = zeros(m,1);





