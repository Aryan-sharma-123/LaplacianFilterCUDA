# NOTE:-
 if LaplacianFilterCUDA.pynb code section doesn't work. Go with second file as I mentioned it separately.


# steps:
 1. Write the commands exactly in the same as mentioned in the file.
 2. The name of the uplaoded input image should be exactly same as mentioned in the code.
 3. In my case it is named as images.jpg
    ![Screenshot 2024-05-22 233737](https://github.com/Aryan-sharma-123/LaplacianFilterCUDA/assets/131610146/89fb2be4-9eb9-4e9b-a3e0-aa22311ba0b4)
4. Wait for some time after successfully executing the commands & code and finally you will see the output image in the file section.
   ![Screenshot 2024-05-22 234108](https://github.com/Aryan-sharma-123/LaplacianFilterCUDA/assets/131610146/6efa5cc1-14c0-444e-8e0b-56da62e19b21)


# Final Results:
  Click on the input & output images on the file section and finally you will see the output.
  
  __Input-Image__:-
    ![Screenshot 2024-05-22 234317](https://github.com/Aryan-sharma-123/LaplacianFilterCUDA/assets/131610146/486899c0-7d54-4a2e-93f9-f43516386a3b)

  __Output-Image__:-
    ![Screenshot 2024-05-22 234409](https://github.com/Aryan-sharma-123/LaplacianFilterCUDA/assets/131610146/546fc014-38a1-4a9f-b262-197771788b43)


# Some Theory:
__Laplacian Filter__:

A Laplacian filter is a type of edge detection filter commonly used in image processing. It highlights regions of an image where there is a rapid change in intensity (i.e., edges). It does this by computing the second derivative of the image intensity at each pixel location. Mathematically, it's represented as the sum of second derivatives in both the x and y directions.

In practice, the Laplacian filter is implemented using a discrete convolution operation with a kernel that approximates the second derivative. The result is a grayscale image where edges are enhanced, making them easier to detect.

__Kernel-Function__:

_boxFilter_: This kernel function performs a simple box filter operation, which is essentially a 3x3 averaging filter. It calculates the average of the pixel values in a 3x3 neighborhood for each pixel in the image.

_sharpeningFilter_: This kernel function implements a sharpening filter, which enhances edges and fine details in the image. It applies a specific kernel ([-1, -1, -1; -1, 9, -1; -1, -1, -1]) to each pixel to enhance the differences between neighboring pixel
