function [target2,cof1,ro] = calAOs(rec,w,x,v,c,ro,targetold,ro1,pdang)
target2=[0,0];
cof1 = 0;
num=size(rec,1);
if num==0 return;end
cof1 = max(w);
if cof1==0 return;end

cc = zeros(num,1);
cc(c>3) = 1;
if sum(cc)==0 return;end

x0=round(rec(:,1)+rec(:,3)/2-0.5+x(:,1)+v(:,1));
y0=round(rec(:,2)+rec(:,4)/2-0.5+x(:,2)+v(:,2));

if pdang==1
    target2(1)=sum(x0.*w.*cc)/sum(w.*cc);
    target2(2)=sum(y0.*w.*cc)/sum(w.*cc);
    return;
end

domain =[targetold(1)-targetold(3)/2+0.5,targetold(2)-targetold(4)/2+0.5,targetold(3)*2,targetold(4)*2];
domain =round(domain);
q=zeros(domain(3),domain(4));
dt = 100;
while dt>2
    target1=target2;
    for i=1:num
        if (w(i)==0 || cc(i)==0) continue;end
        q1=zeros(domain(3),domain(4));
        for j=1:domain(3)
            for k=1:domain(4)
                q1(j,k)=G(j+domain(1)-1-x0(i),k+domain(2)-1-y0(i));
            end
        end
        q=q+q1/w(i);
    end
    s=min(min(q));

    [a,b]=find(q==s);
    target2=[a(1)+domain(1)-1,b(1)+domain(2)-1];
    ros = 0;
    rot = 0;
    for i=1:num
        if (w(i)==0) continue;end
        rot = rot+1/w(i);
        ros = ros+G(target2(1)-x0(i),target2(2)-y0(i))/w(i);
    end
    ro = ros/rot;
    dd = w;
    for i=1:num
        dd(i)=G(target2(1)-x0(i),target2(2)-y0(i));
        if (w(i)==0) continue;end
        w(i)=exp(-G(target2(1)-x0(i),target2(2)-y0(i))/ro1);
    end
    dt=sum((target2-target1).^2,2);
   
end


function t=G(x,y)
t=x^2+y^2;
