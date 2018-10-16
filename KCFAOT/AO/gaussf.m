function q=gaussf(p,ro)
if ro==0
    q = 0;
    if p==0,q = 1;end
    return
end
    
d = acos(-1)*ro;
q = exp(-p/ro)/d;
