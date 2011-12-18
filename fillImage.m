function [ outImgs ] = fillImage(img, dir, rx, ry)

    disp('beginning getMatchingImages...');
    if(rx==0 && ry==0)
        [matches, imgMask] = getMatchingImages(img, dir);
    else
        [matches, imgMask, img] = getMatchingImagesSeam(img, dir, rx, ry);
    end
    disp('done with matching images');
%     count = 0;
    size(matches,2)
    outImgs = cell(1,size(matches,2));
    parfor k=1:size(matches,2)
        match = matches{k};
%         count = count + 1
        completedImg = img;
        matchImg = imread(match);
        tic
        context_match = matchContext(matchImg, img, imgMask);
        toc
        if(context_match.valid==1)
        matchImg = imresize(matchImg, context_match.scale);
%         disp('beginning createAdj...');
%         adjMatrix = createAdjacencyMatrix(img, matchImg, context_match.context_mask, imgMask, context_match.x_t, context_match.y_t);
%         disp('beginning graphCut...');
%         cutMask = graphCut(adjMatrix, context_match.context_match);
        for i=1:size(completedImg,1)
            for j=1:size(completedImg,2)
                if imgMask(i,j) == 0
                    completedImg(i,j,:) = matchImg(i-context_match.x_t,j-context_match.y_t,:);
                end
            end
        end
        blendImg = poissonBlend(matchImg, completedImg, context_match.context_mask, imgMask,context_match.x_t,context_match.y_t);
        outImgs{k} = blendImg;
%         figure
%         imshow(uint8(blendImg));
        end
        outImgs{k} = completedImg;
    end
    
    for i=1:size(outImgs,2)
        figure;
        imshow(uint8(outImgs{i}));
    end
end

