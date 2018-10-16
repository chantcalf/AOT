function r=correct(r,m,n)
if (r(1)<1) r(1) = 1;end
if (r(2)<1) r(2) = 1;end
if (r(1)+r(3)>m+1) r(1) = m+1-r(3);end
if (r(2)+r(4)>n+1) r(2) = n+1-r(4);end
