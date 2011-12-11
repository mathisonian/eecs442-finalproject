function [ output_args ] = fillImage(img, dir)

    [matches, imgMask] = getMatchingImages(img, dir);
    
    for match = matches
        matchImg = imread(match);
        context_match = matchContext(matchImg, img, imgMask);
        adjMatrix = createAdjacencyMatrix(img, matchImg, context_match.context_mask, imgMask, context_match.x_t, context_match.y_t, context_match.scale);
        cutMask = graphCut(adjMatrix, context_match.context_match);
    end

end

