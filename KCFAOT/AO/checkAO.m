function AOs = checkAO(AOs,maxX,maxY)
m = size(AOs,1);
b = zeros(m,1);
for i=1:m
    if (AOs(i).rec(1)<3 || AOs(i).rec(2)<3 || AOs(i).rec(1)+AOs(i).rec(3)>maxX-1 || AOs(i).rec(2)+AOs(i).rec(4)>maxY-1)
        b(i) = 1;
    elseif AOs(i).s<0.6,
            b(i) = 1;
    end
end

AOs(b >0,:) = [];




