function view_segmentation(img,labels,out_path,only_name,display)

[X Y Z] = size(img); L = max(labels); imwrite(img,fullfile(out_path, [only_name '.bmp']));

final_path = fullfile(out_path,int2str(L)); 
mkdir(final_path);

if Z > 1,
    gray_img = rgb2gray(img);
else
    gray_img = img;
end;

%% make the resulted image with red boundaries
OutImgName_1 = fullfile(final_path, [only_name, '_', int2str(L), '_out.bmp']);
disp_img = zeros(X,Y,3);    for i=1:3, disp_img(:,:,i) = gray_img; end; disp_img = img;
label_img = reshape(labels,[X,Y]); [imgMasks,segOutline,imgMarkup]=segoutput(disp_img,label_img);
if display == 1, figure; imshow(imgMarkup); end;
imwrite(imgMarkup,OutImgName_1); 
clear disp_img imgMasks segOutline imgMarkup;

%% divide the image into multiple segments with different colors 
OutImgName_2 = fullfile(final_path, [only_name, '_', int2str(L), '_out_c.bmp']);
disp_img = zeros(X,Y,3);
for i=1:L
    idx = find(labels==i);
    for j=1:3
        tmp = disp_img(:,:,j); tmp1 = img(:,:,j);
        tmp(idx) = mean(tmp1(idx)); 
        disp_img(:,:,j) = tmp; 
        clear tmp tmp1;
    end;
    clear idx;
end;
[imgMasks,segOutline,imgMarkup]=segoutput(disp_img,label_img);
if display == 1, figure; imshow(imgMarkup); end;
imwrite(imgMarkup,OutImgName_2);
clear colors disp_img;

