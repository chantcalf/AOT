function AOs = updateAO(I0,I,AOs,target,param)

n = param.numOfAOs;
a = size(AOs,1);

[maxY,maxX,dum]=size(I);

for i = 1:a
    x = target(1:2)-AOs(i).rec(1:2)+(target(3:4)-AOs(i).rec(3:4))/2;
    AOs(i).w = ker(AOs(i).w,AOs(i).x,AOs(i).v,x);
    AOs(i).v = x-AOs(i).x;
    AOs(i).x = x;
end

if (a<n)
    AOs = selectAOs(AOs,I0,I,target,param,n-a);
end


function q=ker(w,x,v,y)
q = sum((x+v-y).^2,2);
q = 0.2*w+0.8*q;





