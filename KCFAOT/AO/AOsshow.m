function AOsshow(I,target,AOs,f,target1,target2)
%subplot(122);
imshow(I);title(num2str(f));hold on;

x0=target(1);
y0=target(2);
ww=target(3);
h=target(4);
plot([x0,x0+ww,x0+ww,x0,x0],...
    [y0,y0,y0+h,y0+h,y0],'-r','LineWidth',2);

if (target1(1)>0)
    x0=target1(1);
    y0=target1(2);
    ww=target1(3);
    h=target1(4);
    plot([x0,x0+ww,x0+ww,x0,x0],...
    [y0,y0,y0+h,y0+h,y0],'-g','LineWidth',2);
end

if (target2(1)>0)
    x0=target2(1);
    y0=target2(2);
    ww=target2(3);
    h=target2(4);
    plot([x0,x0+ww,x0+ww,x0,x0],...
    [y0,y0,y0+h,y0+h,y0],'-b','LineWidth',2);
end


%{
 if (target1(1)>0)
    x0=round(target1(1)-15);
    y0=round(target1(2)-15);
    plot([x0,x0+30,x0+30,x0,x0],...
        [y0,y0,y0+30,y0+30,y0],'-r','LineWidth',4);
end
%}


m=size(AOs,1);
for i=1:0
    x0=AOs(i).rec(1);
    y0=AOs(i).rec(2);
    ww=AOs(i).rec(3);
    h=AOs(i).rec(4);
    plot([x0,x0+ww,x0+ww,x0,x0],...
        [y0,y0,y0+h,y0+h,y0],'-y','LineWidth',4);
end

pause(0.1);
hold off;
