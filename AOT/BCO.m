function target = BCO(I,target,targetH,hk)
p = imgcrop(I,target);
%subplot(131);imshow(p);
[m,n,kk] = size(p);
q = zeros(m,n);
p = double(p);
d=double(256/hk);
for i = 1:m
    for j = 1:n
        t1=0;  
        for k=1:kk         
            t=floor(p(i,j,k)/d);
            t1=t1*hk+t;
        end
        t1=t1+1;
        q(i,j)=targetH(t1);
    end
end
%subplot(132);imshow(q);
dd = 0.1;
s = sum(q)/m;
i = 1;j = n;
while i<j && s(i)<dd 
    i = i+1;
end

target(1) = target(1)+i-1;

while i<j && s(j)<dd j=j-1;end
target(3) = j-i+1;
q(:,j+1:n)=[];
q(:,1:i-1)=[];
s = sum(q,2)/target(4);
i = 1;j = m;
while i<j && s(i)<dd i = i+1;end
target(2) = target(2)+i-1;

while i<j && s(j)<dd j=j-1;end
target(4) = j-i+1;


%subplot(133);imshow(imgcrop(I,target));
%pause(0.1);