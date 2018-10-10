function [rec,x,v,h,w,c] = checkAO(rec,x,v,h,w,c,s,maxX,maxY)
i1 = rec(:,1) < 3;
i2 = rec(:,2) < 3;
i3 = rec(:,1)+rec(:,3)-1 > maxX-2;
i4 = rec(:,2)+rec(:,4)-1 > maxY-2;
i = zeros(size(rec,1),1);
i(s<0.4) = 1;
i(w>800) = 1;
i=i1+i2+i3+i4+i;
rec(i>0,:) = [];
x(i>0,:) = [];
v(i>0,:) = [];
w(i>0,:) = [];
h(i>0,:) = [];
c(i>0,:) = [];



