function [ output_images ] = runContextMatching( inputImagePath, dataSetDir, xResize, yResize )

%INPUT PARAMETERS:
%inputImagePath - file name of input image
%dataSetDir - directory where images and gist descriptors reside
%xResize - amount of pixels to resize horizontally (positive)
%yResize - amount of pixels to resize vertically

%Outputs an array of image results!

targetImage = imread(inputImagePath);
output_images = fillImage(targetImage,dataSetDir,xResize,yResize);


end

