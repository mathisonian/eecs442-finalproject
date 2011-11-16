function [ matches ] = getMatchingImages( imageName )
    
    GIST_WEIGHT_CONSTANT = 2;
    COLOR_WEIGHT_CONSTANT = 1;

    img = imread(imgName);
    imgMask = roipoly(img);
    imgMask = (imgMask-1).^2;
    
    gist = getGistMask(img, imgMask);
    
    % for each test image
    testGist = getGist(testImg);
    gistSSD = getSSD(img, testImg);
    colorSSD = getColorDiff(img, testImg);
    
    difference = GIST_WEIGHT_CONSTANT*gistSSD 
                    + COLOR_WEIGHT_CONSTANT*colorSSD;
    
end

