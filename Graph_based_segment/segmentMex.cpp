#include "mex.h"
#include "image.h"
#include "misc.h"
#include "segment-image.h"

void mexFunction(
        int         nlhs,
        mxArray     *plhs[],
        int         nrhs,
        const mxArray     *prhs[]
        )
{	
    if( nrhs < 4 )
        mexErrMsgIdAndTxt("segment_mex:","Must have 4 inputs.\n Usage: segmentMex(img,sigma,k,min_size)");
     if( ! mxIsDouble(prhs[1]))
         mexErrMsgIdAndTxt("segment_mex:","sigma must be double");
     //if( ! mxIsInt(prhs[3]))
     //    mexErrMsgIdAndTxt("segment_mex:","min_size must be uint16");
    
    //parse the input argument
    unsigned char *img = (unsigned char *)mxGetData(prhs[0]);
    const int *imgDims = mxGetDimensions(prhs[0]);
    int imgNDim = mxGetNumberOfDimensions(prhs[0]);
    unsigned int width     = imgDims[1];
    unsigned int height    = imgDims[0];
    unsigned int channel   = imgDims[2];
	//mexPrintf("width: %d  height:%d  channel: %d\n",width,height,channel);
    
    double sigma    = (double)mxGetScalar(prhs[1]);
    int   k        = (int)mxGetScalar(prhs[2]);
    int   minSize  = (int)mxGetScalar(prhs[3]);
    
	int compNum = 0;

	//mexPrintf("sigma: %f  k:%d  minSize: %d\n",sigma,k,minSize);
	plhs[0] = mxCreateDoubleMatrix(height,width,mxREAL);
	double *labelImg = mxGetPr(plhs[0]);
	
	universe *mask = segment_image(img,width,height,sigma,k,minSize,&compNum);
	plhs[1] = mxCreateDoubleScalar(compNum);
	for(int i=0; i<height; i++)
	{	
		for(int j=0; j<width; j++)
		{
			labelImg[j*height+i] = mask->find(i*width+j);
			//mexPrintf("%d ",mask->find(i*width+j));
		}
	}

//    file.read((char *)imPtr(im, 0, 0), width * height * sizeof(rgb));

}