function [ matches, imgMask ] = getMatchingImagesSeam( img, indir, extendVal )
    
    GIST_WEIGHT_CONSTANT = 2;
    COLOR_WEIGHT_CONSTANT = 1;
    NUM_MATCHES = 25;
%     gists = cell(1,1000000);
    imgs = cell(1,1000000);
    NUM_IMAGES = getNumImages(indir, 0)

    seamMask = getSeam(img, 1);
    origSize = size(img,2);
    img = [img zeros(size(img,1), extendVal, 3)];
    imgMask = ones(size(img,1), size(img,2));
    for x=1:size(seamMask,1)
        for y=1:size(seamMask,2)
            if seamMask(x,y) == 1
                img(x,end-(origSize-y):end,:) = img(x,y:origSize,:);
                
                img(x,y:y+extendVal-1,1) = img(x,y,1);
                img(x,y:y+extendVal-1,2) = img(x,y,2);
                img(x,y:y+extendVal-1,3) = img(x,y,3);
                imgMask(x,y:y+extendVal-1,:) = zeros(1,extendVal);
            end
        end
    end
    
    imshow(img);
    
    imgGist = getGistMask(img, imgMask);
    tic
    diffs = zeros(1,NUM_IMAGES);
    parfor i=1:NUM_IMAGES
%         testGist = gists{i};
        testGist = load([imgs{i} '.gist'], '-mat');
%         testImg = imread(imgs{i});
        gistSSD = getSSD(imgGist, testGist.gist);
%         disp('getting color ssd');
%         colorSSD = getColorDiff(img, testImg);
        diffs(i) = GIST_WEIGHT_CONSTANT*gistSSD;
%                         + COLOR_WEIGHT_CONSTANT*colorSSD;
    end
    
    [B,IX] = sort(diffs,'descend');
    matches = cell(1,NUM_MATCHES);
    for i=1:NUM_MATCHES
        matches{i} = imgs{IX(i)};
    end
    
    toc
    
    function count = getNumImages(indir, start)
        d = dir(indir);
        count = start;
        
        for j=3:size(d)
            n = [indir '/' d(j).name];
            if(d(j).isdir)
                disp(n);
                count = getNumImages(n, count);
            else
                [a,b,c]=fileparts(n);
                if(strcmp(c,'.gist'))
                    count = count+1;
%                     g = load(n, '-mat');
%                     gists{count} = g.gist;
                    imgs{count} = n(1:end-5);
                end
            end
        end
    end
end

