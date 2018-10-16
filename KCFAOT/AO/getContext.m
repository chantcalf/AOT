function context = getContext(I,target,k)
[maxY,maxX,kk] = size(I);
x0 = target(1)+target(3)/2-0.5;
y0 = target(2)+target(4)/2-0.5;
context = [0,0,target(3)*k,target(4)*k];
context(1) = x0 - context(3)/2+0.5;
context(2) = y0 - context(4)/2+0.5;
context = round(context);
if context(1)<1 context(1)=1;end
if context(2)<1 context(2)=1;end
if context(1)+context(3)-1>maxX context(3)=maxX-context(1)+1;end
if context(2)+context(4)-1>maxY context(4)=maxY-context(2)+1;end

