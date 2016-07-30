% This code is to reproduce the experiments reported in paper
% "Segmentation Using Superpixels: A Bipartite Graph Partitioning Approach"
% Zhenguo Li, Xiao-Ming Wu, and Shih-Fu Chang, CVPR 2012
% {zgli, xmwu, sfchang}@ee.columbia.edu

clc;clear all; close all;

addpath 'msseg'
addpath 'others'
addpath 'evals'
addpath 'algorithms';
addpath 'Graph_based_segment'

%%% set parameters for bipartite graph
para.alpha = 0.001; % affinity between pixels and superpixels
para.beta  =  20;   % scale factor in superpixel affinity
para.nb = 1; % number of neighbors for superpixels

% read numbers of segments used in the paper 
bsdsRoot = 'E:\Coding\Misc\Segmentation\BSDS300';
fid = fopen(fullfile('results','BSDS300','Nsegs.txt'),'r');
Nimgs = 300; % number of images in BSDS300
[BSDS_INFO] = fscanf(fid,'%d %d \n',[2,Nimgs]);
fclose(fid);

PRI_all = zeros(Nimgs,1);
VoI_all = zeros(Nimgs,1);
GCE_all = zeros(Nimgs,1);
BDE_all = zeros(Nimgs,1);

for idxI = 1:Nimgs
    
    % read number of segments
    Nseg = BSDS_INFO(2,idxI);
    
    % locate image
    img_name = int2str(BSDS_INFO(1,idxI));
    img_loc = fullfile(bsdsRoot,'images','test',[img_name,'.jpg']);    
    if ~exist(img_loc,'file')
        img_loc = fullfile(bsdsRoot,'images','train',[img_name,'.jpg']);
    end
    img = im2double(imread(img_loc)); [X,Y,~] = size(img);
    out_path = fullfile('results','BSDS300',img_name);
    mkdir(out_path);
    
    % generate superpixels
    [para_MS, para_FH] = set_parameters_oversegmentation(img_loc);
    [seg,labels_img,seg_vals,seg_lab_vals,seg_edges,seg_img] = make_superpixels(img_loc,para_MS,para_FH);
    
    % save over-segmentations
    view_oversegmentation(labels_img,seg_img,out_path,img_name);
    clear labels_img seg_img;

    % build bipartite graph
    B = build_bipartite_graph(img_loc,para,seg,seg_lab_vals,seg_edges); 
    clear seg seg_lab_vals seg_edges; 
    
    % Transfer Cut
    label_img = Tcut(B,Nseg,[X,Y]); clear B;

    % save segmentation
    view_segmentation(img,label_img(:),out_path,img_name,0);
    
    % evaluate segmentation
    [gt_imgs gt_cnt] = view_gt_segmentation(bsdsRoot,img,BSDS_INFO(1,idxI),out_path,img_name,1); clear img;
    out_vals = eval_segmentation(label_img,gt_imgs); clear label_img gt_imgs;
    fprintf('%6s: %2d %9.6f, %9.6f, %9.6f, %9.6f \n', img_name, Nseg, out_vals.PRI, out_vals.VoI, out_vals.GCE, out_vals.BDE);
    
    PRI_all(idxI) = out_vals.PRI;
    VoI_all(idxI) = out_vals.VoI;
    GCE_all(idxI) = out_vals.GCE;
    BDE_all(idxI) = out_vals.BDE;
end
fprintf('Mean: %14.6f, %9.6f, %9.6f, %9.6f \n', mean(PRI_all), mean(VoI_all), mean(GCE_all), mean(BDE_all));

fid_out = fopen(fullfile('results','BSDS300','evaluation.txt'),'w');
for idxI=1:Nimgs
    fprintf(fid_out,'%6d %9.6f, %9.6f, %9.6f, %9.6f \n', BSDS_INFO(1,idxI), PRI_all(idxI), VoI_all(idxI), GCE_all(idxI), BDE_all(idxI));
end
fprintf(fid_out,'Mean: %10.6f, %9.6f, %9.6f, %9.6f \n', mean(PRI_all), mean(VoI_all), mean(GCE_all), mean(BDE_all));
fclose(fid_out);
