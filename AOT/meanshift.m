function [target,s]=meanshift(I,target,h,hk)
[maxY,maxX,kk]=size(I);
num=0;
d=256/hk;

Y=[2,2]; 
L=hk^kk;
while (Y(1)^2+Y(2)^2>0.5 & num<20)
    num=num+1;
    if (target(1)<1 || target(2)<1 || target(1)+target(3)-1>maxX || target(2)+target(4)-1>maxY ) break;end
    I1=imgcrop(I,target);
    [n,m,kk] = size(I1);
    y=[n/2,m/2];
    h1=hist1(I1,hk);
    w=zeros(1,L);
    for ii=1:L
        if h1(ii)>0
            w(ii)=sqrt(h(ii)/h1(ii));
        end
    end
    
    sw=0;
    xw=[0,0];
    for i=1:n
        for j=1:m
            t1=0;
            for k=1:kk
                t=floor(double(I1(i,j,k))/d);
                t1=t1*hk+t;
            end
            t1=t1+1;
            sw=sw+w(t1);
            xw=xw+w(t1)*[i-y(1)-0.5,j-y(2)-0.5];
        end
    end
    if sw==0 
        find(h>0);
        find(h1>0);
        find(w>0) ;
        break;
    end
    Y=xw/sw;
    target(1)=target(1)+Y(2);
    target(2)=target(2)+Y(1);
    target=round(target);
end
I1=imgcrop(I,target);
h1=hist1(I1,hk);
s=BD(h,h1);
