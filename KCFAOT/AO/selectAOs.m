function AOs = selectAOs(BOs,I0,I,target,param,N)
AOs = BOs;
[maxY,maxX,dummy] = size(I);
rec = selectAOs_F(I0,I,target,param,N*2);
m = size(rec,1);
if m==0
    return;
end

i1 = rec(:,1) < 1;
i2 = rec(:,2) < 1;
i3 = rec(:,1)+rec(:,3)-1 > maxX;
i4 = rec(:,2)+rec(:,4)-1 > maxY;
ii = i1+i2+i3+i4;
for i = 1:m
    if ii(i) == 0
        p = 1;
        for j = 1:size(BOs,1)
            t = cal(rec(i,:),BOs(j,:).rec);
            if (t>=0.5)
                p=0;
                break;
            end
        end
        if p == 0
            ii(i) = 1;
        end
    end
end 

rec(ii>0,:) = [];

m = size(rec,1);
if m==0
    return;
end

if (m>N)
    rec(N+1:m,:) = [];
    m = N;
end

x = zeros(m,2);
v = zeros(m,2);
s = ones(m,1);

x(:,1) = target(1)-rec(:,1)+(target(3)-rec(:,3))/2;
x(:,2) = target(2)-rec(:,2)+(target(4)-rec(:,4))/2;

h = [];
for i = 1:m
    I1 = imgcrop(I,rec(i,1:4));
    h(i,:) = hist1(I1,param.hk);
end

w = ones(m,1)*100;

%[rec,x,v,h,w]
AOs = [];
for i=1:m
    AOs(i,:).rec = rec(i,:);
    AOs(i,:).x = x(i,:);
    AOs(i,:).v = v(i,:);
    AOs(i,:).h = h(i,:);
    AOs(i,:).w = w(i);
    AOs(i,:).s = s(i);
    AOs(i,:).type = findtype(rec(i,:),target);
end
AOs = [BOs;AOs];

function s = findtype(a,b)
t = cal(a,b);
s = 1;
if t == 0
    s = 0;
end
if (a(1)>=b(1) && a(2)>=b(2) && a(1)+a(3)<=b(1)+b(3) && a(2)+a(4)<=b(2)+b(4))
    s = 2;
end


function t=cal(a,b)
x0=max(a(1),b(1));
x1=min(a(1)+a(3),b(1)+b(3));
y0=max(a(2),b(2));
y1=min(a(2)+a(4),b(2)+b(4));
area=0;
if (x0<x1 && y0<y1)
    area=(x1-x0)*(y1-y0);
end
t=area/(a(3)*a(4)+b(3)*b(4)-area);


