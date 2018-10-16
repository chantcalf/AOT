function target2 = calAOs2(I,AOs)

target2=[0,0];

num=size(AOs,1);
if num==0 return;end
rec = [];
w = [];
x = [];
v = [];
for i=1:num
    rec(i,:) = AOs(i).rec;
    w(i,:) = AOs(i).w;
    x(i,:) = AOs(i).x;
    v(i,:) = AOs(i).v;
end

x0=round(rec(:,1)+rec(:,3)/2-0.5+x(:,1)+v(:,1));
y0=round(rec(:,2)+rec(:,4)/2-0.5+x(:,2)+v(:,2));

[m,n,t]=size(I);
dd = 10;

while dd>2
    target1 = target2;
    q=zeros(m,n);
    nn = 0;
    for i=1:num
        
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
    end
    [a,b]=find(q==max(max(q)));
    target2=[b(1),a(1)];
    %dd = sqrt(sum((target2-target1).^2,2));
    dd = 1;
    for i=1:num
        w(i) = (target2(1)-x0(i))^2+(target2(2)-y0(i))^2;
    end
end
target2;
