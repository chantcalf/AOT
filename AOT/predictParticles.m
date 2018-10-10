function [particles,w] = predictParticles(particles,w,param,maxX,maxY)

xyStd = param.xyStd;
whStd = param.whStd;
whd = param.whd;
vd = param.vd;

N = param.numOfParticles;
particles(:,1:2) = round(particles(:,1:2) + [randn(N,1)*xyStd , randn(N,1)*xyStd]);
particles(:,3:4) = round(particles(:,3:4) + [randn(N,1)*whd , randn(N,1)*whd]);
particles(:,3:4) = round(bsxfun(@times,particles(:,3:4),1+randn(N,1)*whStd));
aa = particles(:,3:4);
aa(aa<param.minsize) = param.minsize;
aa(aa>param.maxsize) = param.maxsize;
particles(:,3:4) = aa;
i1 = particles(:,1) < 1;
i2 = particles(:,2) < 1;
particles(i1,1) = 1;
particles(i2,2) = 1;
i3 = particles(:,1)+particles(:,3)-1 > maxX;
i4 = particles(:,2)+particles(:,4)-1 > maxY;
particles(i3,3) = maxX - particles(i3,1);
particles(i4,4) = maxY - particles(i4,2);

i = sum(particles<1,2);
particles(i>0,:)=[];    
w(i>0) = [];