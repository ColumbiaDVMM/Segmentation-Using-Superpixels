function [seg label_img seg_vals seg_lab_vals seg_edges] = gbis(img,lab_vals,sigma,k,minsize)

% call FH 
[label_img, Nseg] = segmentMex(img,sigma,k,minsize);

% convert entries in label map to 1 to Nseg
maxNum = max(label_img(:));
unique_labels = unique(label_img(:));
if length(unique_labels)~= Nseg
    error('Error while segmentation!');
end
SparseIndex = sparse(maxNum,1);
SparseIndex(unique_labels) = 1:length(unique_labels);
label_img = full(SparseIndex(label_img));

% find neighbors among superpixels 
[seg seg_vals seg_lab_vals seg_edges] = make_seg(img,label_img,lab_vals,0);