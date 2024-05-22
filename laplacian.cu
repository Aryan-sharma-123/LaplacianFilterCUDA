%%writefile laplacian.cu
#include <stdio.h>
#include <opencv2/core/core.hpp> // Include core functionalities
#include <opencv2/imgcodecs.hpp> // For imread and imwrite
#include <opencv2/highgui/highgui.hpp> // For GUI functionalities, might not be necessary for this script

using namespace cv; // Use the cv namespace to simplify code

__global__ void boxFilter(unsigned char *srcImage, unsigned char *dstImage, unsigned int width, unsigned int height, int channel)
{
   int x = blockIdx.x*blockDim.x + threadIdx.x;
   int y = blockIdx.y*blockDim.y + threadIdx.y;

   // only threads inside image will write results
   if((x>=3/2) && (x<(width-3/2)) && (y>=3/2) && (y<(height-3/2)))
   {
      for(int c=0 ; c<channel ; c++)
      {
         // Sum of pixel values
         float sum = 0;
         // Number of filter pixels
         float kS = 0;
         // Loop inside the filter to average pixel values
         for(int ky=-3/2; ky<=3/2; ky++) {
            for(int kx=-3/2; kx<=3/2; kx++) {
               float fl = srcImage[((y+ky)*width + (x+kx))*channel+c];
               sum += fl;
               kS += 1;
            }
         }
         dstImage[(y*width+x)*channel+c] =  sum / kS;
      }
   }
}

__global__ void sharpeningFilter(unsigned char *srcImage, unsigned char *dstImage, unsigned int width, unsigned int height, int channel)
{
   int x = blockIdx.x*blockDim.x + threadIdx.x;
   int y = blockIdx.y*blockDim.y + threadIdx.y;

   float kernel[3][3] = {-1, -1, -1, -1, 9, -1, -1, -1, -1};
   // only threads inside image will write results
   if((x>=3/2) && (x<(width-3/2)) && (y>=3/2) && (y<(height-3/2)))
   {
      for(int c=0 ; c<channel ; c++)
      {
         // Sum of pixel values
         float sum = 0;
         // Loop inside the filter to average pixel values
         for(int ky=-3/2; ky<=3/2; ky++) {
            for(int kx=-3/2; kx<=3/2; kx++) {
               float fl = srcImage[((y+ky)*width + (x+kx))*channel+c];
               sum += fl*kernel[ky+3/2][kx+3/2];
            }
         }
         dstImage[(y*width+x)*channel+c] =  sum;
      }
   }
}

void checkCudaErrors(cudaError_t r) {
    if (r != cudaSuccess) {
        fprintf(stderr, "CUDA Error: %s\n", cudaGetErrorString(r));
        exit(EXIT_FAILURE);
    }
}

int main() {
    Mat image = imread("images.jpg", IMREAD_GRAYSCALE);
    if (image.empty()) {
        printf("Error: Image not found.\n");
        return -1;
    }
    int width = image.cols;
    int height = image.rows;
    int channel=image.step/image.cols;
    size_t imageSize = width * height * sizeof(unsigned char);

    unsigned char *h_outputImage = (unsigned char *)malloc(imageSize);
    if (h_outputImage == nullptr) {
        fprintf(stderr, "Failed to allocate host memory\n");
        return -1;
    }

    unsigned char *d_inputImage, *d_outputImage;
    checkCudaErrors(cudaMalloc(&d_inputImage, imageSize));
    checkCudaErrors(cudaMalloc(&d_outputImage, imageSize));
    checkCudaErrors(cudaMemcpy(d_inputImage, image.data, imageSize, cudaMemcpyHostToDevice));

    dim3 blockSize(16, 16);
    dim3 gridSize(ceil(width/16.0),ceil(height/16.0));
    boxFilter<<<gridSize,blockSize>>>(d_inputImage,d_outputImage,width,height,channel);
    sharpeningFilter<<<gridSize,blockSize>>>(d_outputImage,d_inputImage,width,height,channel);
    checkCudaErrors(cudaMemcpy(h_outputImage, d_inputImage, imageSize, cudaMemcpyDeviceToHost));

    Mat outputImage(height, width, CV_8UC1, h_outputImage);
    imwrite("output.jpeg", outputImage);

    free(h_outputImage);
    cudaFree(d_inputImage);
    cudaFree(d_outputImage);

    return 0;
}