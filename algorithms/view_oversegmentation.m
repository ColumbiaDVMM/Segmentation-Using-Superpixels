function view_oversegmentation(label_img,seg_img,out_path,only_name)

mkdir(fullfile(out_path,'segs'));

%% make the resulted image with red boundaries
for i=1:size(label_img,2)
    [imgMasks,segOutline,imgMarkup]=segoutput(seg_img{i},double(label_img{i}));
    imwrite(imgMarkup,fullfile(out_path,'segs', [only_name, '_', int2str(i) '.bmp'])); 
    clear imgMasks segOutline imgMarkup;
end