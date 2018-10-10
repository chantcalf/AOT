function s=checkT(I,rec)

p=imgcrop(I,rec);
s=sum(sum(p,2))/rec(3)/rec(4);

