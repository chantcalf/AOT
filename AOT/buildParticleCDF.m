function [particles,CDF] = buildParticleCDF(particles,w)

[particles] = sortrows([particles,w],size(particles,2)+1);
w = particles(:,end);
particles(:,end) = [];
CDF = cumsum(w);