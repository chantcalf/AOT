function q=TBC(I,h,hk)
[m,n,kk] = size(I);
q = zeros(m,n);
%subplot(121);imshow(I);
I=double(I);
d=double(256/hk);
for i=1:m
    for j=1:n
        t1=0;  
        for k=1:kk         
            t=floor(I(i,j,k)/d);
            t1=t1*hk+t;
        end
        t1=t1+1;
        q(i,j)=h(t1);
    end
end

%subplot(122);imshow(q);
%pause(0.1);