function [target] = updateTargetState(targetOld,particles,w,param,maxX,maxY)
ind = find(sum(isnan(particles),2));
particles(ind,:) = [];
w(ind) = [];
target = sum(bsxfun(@times,particles,w),1);
target(3:4) = targetOld(3:4)*(0.8) + target(3:4)*0.2;
target = fix(target);
if target(1)<1
    target(1) = 1;
end
if target(2)<1
    target(2) = 1;
end
if target(1)+target(3)-1>maxX
    target(3) = maxX-target(1);
end
if target(2)+target(4)-1>maxY
    target(4) = maxY-target(2);
end
if target(1)+target(3)-1>maxX
    target(1) = maxX-target(3);
end
if target(2)+target(4)-1>maxY
    target(2) = maxY-target(4);
end

