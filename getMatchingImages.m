function [ matches ] = getMatchingImages( img, indir )
    
    GIST_WEIGHT_CONSTANT = 2;
    COLOR_WEIGHT_CONSTANT = 1;
    NUM_MATCHES = 100;
    gists = [];
    imgs = [];
    NUM_IMAGES = getNumImages(indir);

    imgMask = roipoly(img);
    imgMask = (imgMask-1).^2;
    imgGist = getGistMask(img, imgMask);
    
    diffs = zeros(1,NUM_IMAGES);
   
    parfor i=1:NUM_IMAGES
        testGist = gists(i);
        testImg = imread(imgs(i));
        gistSSD = getSSD(imgGist, testGist);
        colorSSD = getColorDiff(img, testImg);
        diffs(i) = GIST_WEIGHT_CONSTANT*gistSSD 
                        + COLOR_WEIGHT_CONSTANT*colorSSD;
    end
    
    [B,IX] = sort(diffs,'descend');
    for i=1:NUM_MATCHES
        matches(i) = imgs(IX(i));
    end
    
    function n = getNumImages(indir)
        d = dir(indir);
        count = 0;
        
        for j=3:size(mydir)
            n = [indir '\' d(j).name];
            if(d(j).isdir)
                count = count + getNumImages(n);
            else
                [a,b,c]=fileparts(n);
                if(strcmp(c,'.gist'))
                    count = count+1;
                    gists = [gists, load(n, 'gist')];
                else
                    imgs = [imgs, n];
                end
            end
        end
    end
end

