##Segmentation by Aggregating Superpixels [code]
----
####Terms of Use

Copyright (c) 2012 by DVMM Laboratory

Department of Electrical Engineering</br>
Columbia University</br>
Rm 1312 S.W. Mudd, 500 West 120th Street</br>
New York, NY 10027</br>
USA


If it is your intention to use this code for non-commercial purposes, such as in academic research, this code is free.

If you use this code in your research, please acknowledge the authors, and cite our related publication:

"Segmentation Using Superpixels: A Bipartite Graph Partitioning Approach" by Zhenguo Li, Xiao-Ming Wu, and Shih-Fu Chang in IEEE International Conference on Computer Vision and Pattern Recognition (CVPR), 2012.

####Instruction
This code is to implement the segmentation method desribed in: 

It is written in MATLAB with C++ mex files, and has been tested under windows and linux. 

To reproduce the results reported in our paper, first download the benchmark dataset BSDS300 (including "Images" and "Human segmentations") from http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/ and then set the BSDS300 directory path to a variable "bsdsRoot" in "demo_SAS_BSDS.m". 

We remark that part of this code is modified from the code of Tae Hoon Kim et al. for their CVPR10 paper.

If you use our code, please cite our paper. For any question, please contact us via the E-mail: zgli@ee.columbia.edu.

