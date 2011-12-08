function [ g ] = getGist( img )
    % Parameters:
    Nblocks = 4;
    imageSize = 128; 
    orientationsPerScale = [6 6 6 6 6];
    numberBlocks = 4;
    
    imgSizeX = size(img, 1);
    imgSizeY = size(img, 2);

    % Precompute filter transfert functions (only need to do this one, unless image size is changes):
    % createGabor(orientationsPerScale, imageSize); % this shows the filters
    G = createGabor(orientationsPerScale, imgSizeX, imgSizeY);

    % Computing gist requires 1) prefilter image, 2) filter image and collect
    % output energies
    output = prefilt(double(img), 2);
    g = gistGabor(output, numberBlocks, G);
end

