function [ output_args ] = fillImage(img, dir)

    disp('beginning getMatchingImages...');
    [matches, imgMask] = getMatchingImages(img, dir);
    disp('done with matching images');
    count = 0;
    size(matches,2)
    for k=1:size(matches,2)
        match = matches{k};
        count = count + 1
        completedImg = img;
        matchImg = imread(match);
        tic
        context_match = matchContext(matchImg, img, imgMask);
        toc
        matchImg = imresize(matchImg, context_match.scale);
        disp('beginning createAdj...');
        adjMatrix = createAdjacencyMatrix(img, matchImg, context_match.context_mask, imgMask, context_match.x_t, context_match.y_t);
        disp('beginning graphCut...');
        cutMask = graphCut(adjMatrix, context_match.context_match);
        for i=1:size(cutMask,1)
            for j=1:size(cutMask,2)
                if cutMask(i,j) > 1
                    completedImg(i,j,:) = matchImg(i-context_match.x_t,j-context_match.y_t,:);
                end
            end
        end
        figure
        imshow(completedImg);
    end

end

