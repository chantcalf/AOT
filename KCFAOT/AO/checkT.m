function s=checkT(I,rec)

m = size(I,1);
n = size(I,2);
rec1 = [rec(1),rec(2),rec(1)+rec(3)-1,rec(2)+rec(4)-1];
rec1(rec1<1) = 1;
if rec1(3)>n
    rec1(3) = n;
end
if rec1(4)>m
    rec1(4) = m;
end
rec = [rec1(1),rec1(2),rec1(3)-rec1(1)+1,rec1(4)-rec1(2)+1];

a = rec(4);
b = rec(3);
y(1)=a/2;
y(2)=b/2;

m_wei=ones(a,b);

h=y(1)^2+y(2)^2 ;

for i=1:a
    for j=1:b
        dist=(i-y(1))^2+(j-y(2))^2;
        m_wei(i,j)=1-(dist/h)^0.5; 
    end
end

C=1/sum(sum(m_wei));

p=imgcrop(I,rec);
p = p.*m_wei;
s=sum(sum(p,2))*C;
%{
p=imgcrop(I,rec);
s=sum(sum(p,2))/rec(3)/rec(4);
%}
