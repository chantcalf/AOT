function B = isBackgroundClutter(II,target,sx0,s)

ss = sum(sum(imgcrop(II,target),2))/target(3)/target(4);
context = getContext(II,target,2);
ssc = sum(sum(imgcrop(II,context),2))/target(3)/target(4) - ss;
sx = ssc/ss;

B = 0;
if ((sx>1) || ss < s*0.5)
    B = 1;
end