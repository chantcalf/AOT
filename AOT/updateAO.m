function [rec,Ax,Av,Ah,Aw,Ac] = updateAO(I,II,rec,Ax,Av,Ah,Aw,Ac,target,param,p,pdx)

Ac = Ac+1;

if (p==1) 
    return;
end

n = param.numOfAOs;
a = size(rec,1);

if (pdx==1) Ac = zeros(a,1);end

ro = param.ro1;
[maxY,maxX,dum]=size(I);
kk = 4/maxX/maxY;

x = ones(a,1)*target(1:2)-rec(:,1:2)+(ones(a,1)*target(3:4)-rec(:,3:4))/2;

for i = 1:a
    	Aw(i) = ker(Aw(i),Ax(i,:),Av(i,:),x(i,:),ro,kk);
end

%[Aw,[Ax(:,4),Ay(:,4)],x]
Av = x-Ax;
Ax = x;

%{
if (a>n/2)
    [Aw,b]=sort(Aw,'descend');
    t=[];
    for i=1:a
        t(i,:)=AOs(b(i,1),:);
    end
    AOs=t;
    t=[];
    for i=1:a
        t(i,:)=fh(b(i,1),:);
    end
    fh=t;
    while a>0 && Aw(a)<0 
        a=a-1;
    end
end
a=a+1;
AOs(a:size(AOs,1),:)=[];
Aw(a:size(Aw,1),:)=[];
%}

if (a<n)
    [Brec,Bx,Bv,Bh,Bw,Bc] = selectAOs(I,II,target,param,n-a+1);
    rec = [rec;Brec];
    Ax=[Ax;Bx];
    Av=[Av;Bv];
    Aw=[Aw;Bw];
    Ah=[Ah;Bh];
    Ac=[Ac;Bc];
end


function q=ker(w,x,v,y,ro,k)
%q = sum((x+v-y).^2,2)+k*sum(y.^2,2);
%q = exp(-q/ro);
q = sum((x+v-y).^2,2);
q = 0.2*w+0.8*q;





