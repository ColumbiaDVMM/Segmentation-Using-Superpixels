clear;
clc;
% add '-g' to debug the cpp function
mex -I.\ -O segmentMex.cpp 
fprintf('compilation done~!\n');