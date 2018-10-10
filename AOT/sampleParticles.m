function [particles,w] = sampleParticles(particles,w,CDF,N)

[dummy,M] = size(particles);
sampledParticles = zeros(N,M);
sampledWeights = zeros(N,1);
for n = 1:N
        r = rand;
        idx = sum(CDF < r) + 1;
        sampledParticles(n,:) = particles(idx,:);
        sampledWeights(n) = w(idx);
end

particles = sampledParticles;
w = sampledWeights;
%w = sampledWeights/sum(sampledWeights(:));