function [ adjMatrix ] = createAdjacencyMatrix(img, match, context, mask)

    s = size(context);
    w = s(1);
    h = s(2);
    
    
    contextMap = zeros(w,h);
    count = 1;
    for i = 1:w
        for j = 1:h
            if context(i,j) == 1
                contextMap(i,j) = count;
                count = count + 1;
            end
        end
    end
    
    adjMatrix = zeros(count+1,count+1);
    originalImage = count;
    hole = count+1;
    
    for i = 1:w
        for j = 1:h
            if context(i,j) == 1
                % test pixel to the left
                if context(i-1,j) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i-1,j)) = getGradientMagnitude(i,j,i-1,j, img, match);
                elseif mask(i-1,j) == 0 
                    % create edge p->hole
                    adjMatrix(contextMap(i,j),hole) = Inf;
                else
                    % create edge orig->p
                    adjMatrix(originalImage, contextMap(i,j)) = Inf; 
                end
                
                % test pixel above
                if context(i, j-1) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i,j-1)) = getGradientMagnitude(i,j,i,j-1, img, match);
                elseif mask(i,j-1) == 0 
                    % create edge p->hole
                    adjMatrix(contextMap(i,j),hole) = Inf;
                else
                    % create edge orig->p
                    adjMatrix(originalImage, contextMap(i,j)) = Inf;
                end
                % test pixel to the right
                if context(i+1, j) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i+1,j)) = getGradientMagnitude(i,j,i+1,j, img, match);
                elseif mask(i+1,j) == 0 
                    % create edge p->hole
                    adjMatrix(contextMap(i,j),hole) = Inf;
                else
                    % create edge orig->p
                    adjMatrix(originalImage, contextMap(i,j)) = Inf;
                end
                % test pixel below
                if context(i, j+1) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i,j+1)) = getGradientMagnitude(i,j,i,j+1, img, match);
                elseif mask(i,j+1) == 0 
                    % create edge p->hole
                    adjMatrix(contextMap(i,j),hole) = Inf;
                else
                    % create edge orig->p
                    adjMatrix(originalImage, contextMap(i,j)) = Inf;
                end
            end
        end 
    end

end

