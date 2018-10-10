function [particles w] = updateParticles(target,particles,w,maxX,maxY,param,pd)

n0=size(w,1);
if pd==0
    w=ones(n0,1)/n0;
end

% Build CDF



% Sample new particles according to CDF
n1=floor(param.numOfParticles*2/3);
%if pd==0
    n1=floor(param.numOfParticles*0.7);
    [particles,CDF] = buildParticleCDF(particles,w);
    [particles,w] = sampleParticles(particles,w,CDF,n1);
%end

n2=param.numOfParticles-n1;
p2 = [ones(n2,1)*target];
w2 = ones(n2,1)/param.numOfParticles;
particles(n1+1:param.numOfParticles,:) = p2;
w(n1+1:param.numOfParticles) = w2;
w = w/sum(w);

% Predict new particles state based on state model + Noise
[particles,w] = predictParticles(particles,w,param,maxX,maxY);
