function p = uda(I,AOs)
p = I;
for i=1:size(AOs,1)
    rec = AOs(i,:).rec;
    t = AOs(i,:).type;
    for x=rec(1):rec(1)+rec(3)-1
        for y=rec(2):rec(2)+rec(4)-1
            p(y,x) = p(y,x)*t/2;
        end
    end
end
