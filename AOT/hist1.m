function q=hist1(p,hk)
[a,b,c]=size(p); 

y(1)=a/2;
y(2)=b/2;
m_wei=zeros(a,b);
h=y(1)^2+y(2)^2 ;
d=256/hk;


for i=1:a
    for j=1:b
        dist=(i-y(1))^2+(j-y(2))^2;
        m_wei(i,j)=1-dist/h; 
    end
end
C=1/sum(sum(m_wei));

q=zeros(1,hk^c);
p=double(p);
for i=1:a
    for j=1:b
        t1=0;
        for k=1:c         
            t=floor(p(i,j,k)/d);
            t1=t1*hk+t;
        end
        t1=t1+1;    
        q(t1)= q(t1)+m_wei(i,j); 
    end
end
q=q*C;

    
