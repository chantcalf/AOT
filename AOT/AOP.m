function [s,e] = AOP(x)
%x=[2,4,2,3];
i=1:1:4;
p=polyfit(i,x,2);
j=1:1:5;
y=fc(p,j);
s=y(1,5);
e = sqrt(sum((y(1,1:4)-x).^2,2));
j=1:0.1:5;
y=fc(p,j);
%{
plot(j,y,'b');hold on;
plot(i,x,'ro');
%}



function y=fc(p,x)
n=size(p,2);
k(n,:)=ones(1,size(x,2));
for i=n-1:-1:1
    k(i,:)=k(i+1,:).*x;
end
y=p*k;






