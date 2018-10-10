function [I] = loadFrame(fileName,DS)

if nargin == 1
    DS = 1;
end

% Load image
[pathstr,name,ext] = fileparts(fileName);
fullName = dir(strcat(fileName,'*'));
I = imread(fullfile(pathstr,fullName.name));

% Down sample image (if needed)
if DS < 1
    I = imresize(I,DS);
end

% If gray scale image replicate to 3 channels
if size(I,3)==1
    I = repmat(I,[1,1,3]);
end