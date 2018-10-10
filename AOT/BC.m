function [targetH,s] = BC(I,target,hk)
[maxY,maxX,kk] = size(I);

context = [target(1)-(target(3)-1)/2,target(2)-(target(4)-1)/2,target(3)*2,target(4)*2];
context = round(context);
if context(1)<1 context(1)=1;end
if context(2)<1 context(2)=1;end
if context(1)+context(3)-1>maxX context(3)=maxX-context(1)+1;end
if context(2)+context(4)-1>maxY context(4)=maxY-context(2)+1;end
p = imgcrop(I,target);
pc = imgcrop(I,context);
ht = hh(p,hk);
hc = hh(pc,hk);
targetH = zeros(1,hk^kk)*0.5;
targetH(hc>0) = ht(hc>0)./hc(hc>0);

%{
subplot(141);imshow(p);
subplot(142);imshow(pc);
%}

[m,n,k]=size(p);
q = zeros(m,n);
p=double(p);
d=double(256/hk);
for i=1:m
    for j=1:n
        t1=0;  
        for k=1:kk         
            t=floor(p(i,j,k)/d);
            t1=t1*hk+t;
        end
        t1=t1+1;
        q(i,j)=targetH(t1);
    end
end
s=sum(sum(q,2))/m/n;
%{
subplot(143);imshow(q);

q(q<s)=0;
q(q>=s)=1;
subplot(144);imshow(q);
pause(0.1);
%}



function h = hh(p,hk)

[m,n,kk]=size(p);
h = zeros(1,hk^kk);
d=double(256/hk);
for i = 1:m
    for j = 1:n
        t1=0;  
        for k=1:kk         
            t=floor(double(p(i,j,k))/d);
            t1=t1*hk+t;
        end
        t1=t1+1;
        h(t1) = h(t1)+1;
    end
end



        
        