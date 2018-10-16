function q=pr(I,rec)
m = size(I,1);
n = size(I,2);
q = zeros(m,n);
h = rec(3)^2+rec(4)^2;
h = h*2;
x = rec(1:2)+floor(rec(3:4)/2);
for i=1:m
    for j=1:n
        
        q(i,j) = 1-((i-x(2))^2+(j-x(1))^2)/h;
        if q(i,j)<0
            q(i,j)=0;
        end
        %{
        if ((i-x(2))^2+(j-x(1))^2<h)
            q(i,j)=1;
        end
        %}
    end
end
