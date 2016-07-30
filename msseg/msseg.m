% Performing mean_shift image segmentation using EDISON code implementation
% of Comaniciu's paper with a MEX wrapper from Shai Bagon. links at bottom
% of help
%
% Usage:
%   [S L] = msseg(I,hs,hr,M)
%    
% Inputs:
%   I  - original image in RGB or grayscale
%   hs - spatial bandwith for mean shift analysis
%   hr - range bandwidth for mean shift analysis
%   M  - minimum size of final output regions
%
% Outputs:
%   S  - segmented image
%   L  - resulting label map
%
% Links:
% Comaniciu's Paper
%  http://www.caip.rutgers.edu/riul/research/papers/abstract/mnshft.html
% EDISON code
%  http://www.caip.rutgers.edu/riul/research/code/EDISON/index.html
% Shai's mex wrapper code
%  http://www.wisdom.weizmann.ac.il/~bagon/matlab.html
%
% Author:
%  This file and re-wrapping by Shawn Lankton (www.shawnlankton.com)
%  Nov. 2007
%------------------------------------------------------------------------

function [S L seg seg_vals seg_lab_vals seg_edges] = msseg(img,lab_vals,hs,hr,M,full)
  gray = 0;
  if(size(img,3)==1)
    gray = 1;
    I = repmat(img,[1 1 3]);
  end
  
  if(nargin < 5)
    hs = 10; hr = 7; M = 30;
  end
  
  if(nargin < 6)
    full = 0;
  end
    
  [fimg labels modes regsize grad conf] = edison_wrapper(img,@RGB2Luv,...
      'SpatialBandWidth',hs,'RangeBandWidth',hr,...
      'MinimumRegionArea',M,'speedup',3);
  
  S = fimg; %Luv2RGB(fimg); 
  L = labels + 1; 

  if(gray == 1)
    S = rgb2gray(S);
  end
  
  [X,Y,Z] = size(img); nseg = max(L(:)); vals = reshape(img,X*Y,Z);
  
  if full == 1,
      [x y] = meshgrid(1:nseg,1:nseg);
      seg_edges = [x(:) y(:)];
  else
      [points edges]=lattice(X,Y,0);    clear points;
      d_edges = edges(find(L(edges(:,1))~=L(edges(:,2))),:);
      all_seg_edges = [L(d_edges(:,1)) L(d_edges(:,2))]; all_seg_edges = sort(all_seg_edges,2);
  
      tmp = zeros(nseg,nseg);
      tmp(nseg*(all_seg_edges(:,1)-1)+all_seg_edges(:,2)) = 1;
      [edges_x edges_y] = find(tmp==1); seg_edges = [edges_x edges_y];
  end;

  seg_vals = zeros(nseg,Z);
  seg_lab_vals = zeros(nseg,size(lab_vals,2));
  for i=1:nseg
    seg{i} = find(L(:)==i);
    seg_vals(i,:) = mean(vals(seg{i},:));
    seg_lab_vals(i,:) = mean(lab_vals(seg{i},:));
  end;
  
  
