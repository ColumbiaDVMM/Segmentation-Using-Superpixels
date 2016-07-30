% function oversegment_demo(img)
close all;

% img = imread('4_29_s.bmp');
img = imread('E:\Codes\Segmentation\BSDS300\images\train\15088.jpg');
figure,imshow(img);
tic;
[labels regSize] = segmentMex(img,0.5,200,150);
toc;
maxNum = max(labels(:));
Unique_a = unique(labels);
if length(Unique_a)~= regSize
    fprintf('error while segmentation~!\n');
    return;
end
SparseIndex = sparse(maxNum,1);
SparseIndex(Unique_a) = 1:size(Unique_a);
labels = full(SparseIndex(labels));

% display segmention mask with colors
psuColor = [255 0 0;  0 255 0; 0 0 255;255 255 0;
            255 0 255; 0 255 255; 255 255 255;];
        
chan1 = zeros(size(labels));
chan2 = zeros(size(labels));
chan3 = zeros(size(labels));

for i=1:regSize
    colorInx = mod(i,7) + (~mod(i,7))*7;
    chan1(labels == i) = psuColor(colorInx,1);
    chan2(labels == i) = psuColor(colorInx,2);
    chan3(labels == i) = psuColor(colorInx,3);
end

mask = cat(3,chan1,chan2,chan3);
clear chan1 chan2 chan3 SparseIndex Unique_a
figure;imshow(mask);title(num2str(regSize));
% end
