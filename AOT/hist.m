function q=hist(p,target,num)
[n,m,kk] = size(p);
x0=target(1);
y0=target(2);
x1=x0+target(3)-1;
y1=y0+target(4)-1;
%q=zeros(1,128);
q=zeros(1,num^kk);
d=double(256/num);
cd=sqrt(target(3)^2+target(4)^2)/2;
zx=(x0+x1)/2.0;
zy=(y0+y1)/2.0;
p=double(p);
if (x0>0 && x1<=m && y0>0 && y1<=n)
    for i=y0:y1
        for j=x0:x1
            t1=0;
            
            for k=1:kk         
                t=floor(p(i,j,k)/d);
                t1=t1*num+t;
            end
            
            
            t1=t1+1;
            a=sqrt((i-zy)^2+(j-zx)^2)/cd;
            b=0;
            if a<1
                b=1-a;
            end
            q(t1)=q(t1)+b;
        end
    end
    tt=sum(q');
    if tt~=0
        q=q/tt;
    end
end
