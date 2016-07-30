function [regMask regNum] = segment(img,sigma,k,min_size)
% Segment an image into superpixels, and return their region masks
%
% Input: im:        image to segment.
%        sigma:     to smooth the image.
%        k:         constant for threshold function.
%        min_size:  minimum component size (enforced by post-processing stage).
% Output:regMaks:   region mask with each region corresponding to a unique
%                   number, ranging from 1 to regNum.
%        regNum:    total number of connected components, that is, regions

[regMask regNum] = segmentMex(img,sigma,k,min_size);

%-------- convert regMask number to [1 regNum]
% maxNum = max(regMask(:));
% Unique_a = unique(regMask);
% if length(Unique_a)~= regNum
%     fprintf('error while segmentation~!\n');
%     return;
% end
% SparseIndex = sparse(maxNum,1);
% SparseIndex(Unique_a) = 1:size(Unique_a);
% regMask = full(SparseIndex(regMask));

end