function [x,y] = predictAOs(rec,x,y,t,p)

m = size(rec,1);
if m==0 || p==1 return;end

%{
x1 = zeros(m,1);
y1 = zeros(m,1);
ex = zeros(m,1);
ey = zeros(m,1);
for i = 1:m
    if (t(i,1)>4)
        [x1(i,1),ex(i,1)] = AOP(x(i,:));
        [y1(i,1),ey(i,1)] = AOP(y(i,:));
    end
end
%}
x(:,1:3) = x(:,2:4);
%x(:,4) = x1(:,1);
y(:,1:3) = y(:,2:4);
%y(:,4) = y1(:,1);

