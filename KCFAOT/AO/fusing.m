function t = fusing(II,II1,target,rec,dmin,dmax,B)
[m,n] = size(II);
t = target;
x0 = target(1);
y0 = target(2);
x1 = rec(1);
y1 = rec(2);
if (x1==0 && y1==0)
    return;
end
d = (x0-x1)^2+(y0-y1)^2

if d<dmin 
    return;
end

II = II.*II1;

if d>dmax
    %{
    if B==1
        return;
    end
    %}
    tr = rec;
    wd = checkT(II,t)
    wdr = checkT(II,tr)
    if (wdr>wd)
        t = tr;
    end
       
    return;
end



if (x0>x1)
    temp = x0;x0=x1;x1=temp;
end
if (y0>y1)
    temp = y0;y0=y1;y1=temp;
end
s0 = 0;
if (t(1)>0 && t(2)>0 && t(1)+rec(3)<n && t(2)+rec(4)<m)
    s0 = checkT(II,t);
end

for i=x0-5:x1+5
    for j=y0-5:y1+5
        if (i>0 && j>0 && i+rec(3)<n && j+rec(4)<m)
            t1 = [i,j,rec(3),rec(4)];
            s1 = checkT(II,t1);
            if (s1>s0)
                t = t1;
                s0 = s1;
            end
        end
    end
end

