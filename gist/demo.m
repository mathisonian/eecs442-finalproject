% Load image
img = imread('test.jpg');

% Parameters:
Nblocks = 4;
imageSize = 128; 
orientationsPerScale = [6 6 6 6 6];
numberBlocks = 4;

% Precompute filter transfert functions (only need to do this one, unless image size is changes):
% createGabor(orientationsPerScale, imageSize); % this shows the filters
G = createGabor(orientationsPerScale, imageSize);

% Computing gist requires 1) prefilter image, 2) filter image and collect
% output energies
output = prefilt(double(img), 2);
g = gistGabor(output, numberBlocks, G);

size(g)

% Visualization
figure
subplot(221)
imshow(img)
title('Input image')
subplot(222)
o = 128+128*output/max(abs(output(:)));
imshow(uint8(o))
title('Prefiltered image')
subplot(212)
plot(g)
title('Descriptor')