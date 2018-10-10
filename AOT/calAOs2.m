function [target2,cof1] = calAOs2(I,rec,w,x,v,c,pdang)
target2=[0,0];
cof1 = 0;
num=size(rec,1);
if num==0 return;end
cof1 = max(w);

if cof1==0 return;end
cof1 = size(w(w>0),1)/20;
if cof1>1 cof1=1;end

x0=round(rec(:,1)+rec(:,3)/2-0.5+x(:,1)+v(:,1));
y0=round(rec(:,2)+rec(:,4)/2-0.5+x(:,2)+v(:,2));
%{
if pdang==1
    cc = zeros(num,1);
    cc(c>2) = 1;
    target2(1)=sum(x0.*w.*cc)/sum(w.*cc);
    target2(2)=sum(y0.*w.*cc)/sum(w.*cc);
    return;
end
%}

[m,n,t]=size(I);
q=zeros(m,n);
nn = 0;
for i=1:num
    if (w(i)==0) continue;end
    nn = nn+1;
    
    d=round(sqrt(w(i))*3);
    for j=-d:d
        for k=-d:d
            yy=y0(i)+j;
            xx=x0(i)+k;
            if (yy>0 && yy<=m && xx>0 && xx<=n)
                q(yy,xx)=q(yy,xx)+gaussf(j*j+k*k,w(i));
            end
        end
    end

    %{
    for j=1:m
        for k=1:n
            q(j,k)=q(j,k)+((j-y0(i))^2+(k-x0(i))^2)/w(i);
        end
    end
    %}
end
%{
q=q/nn;
q=q/(max(max(q)));
q(q>0)
d=gaussf(rec(3)^2+rec(4)^2,max(w))
q(q>0)=1;

imshow(q);
pause(0.1);
pause(10)
%}
%q=q/sum(w);
%s=max(max(q));
%q=q/s;

%imshow(q);
%pause(0.1);
[a,b]=find(q==max(max(q)));
target2=[b,a];

