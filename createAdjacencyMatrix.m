function [ adjMatrix ] = createAdjacencyMatrix(img, match, context, mask, x_t, y_t)

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
    
    cform = makecform('srgb2lab');
    lab1 = double(applycform(img,cform));
    lab2 = double(applycform(match,cform));
    
    for i = 1:w
        for j = 1:h
            j
            if context(i,j) == 1
                % test pixel to the left
                if i > 1 && context(i-1,j) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i-1,j)) = getGradientMagnitude(i,j,i-1,j, lab1, lab2, x_t, y_t);
                elseif i > 1 && mask(i-1,j) == 0 
                    % create edge p->hole
                    adjMatrix(contextMap(i,j),hole) = Inf;
                else
                    % create edge orig->p
                    adjMatrix(originalImage, contextMap(i,j)) = Inf; 
                end
                
                % test pixel above
                if j > 1 && context(i, j-1) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i,j-1)) = getGradientMagnitude(i,j,i,j-1, lab1, lab2, x_t, y_t);
                elseif j > 1 && mask(i,j-1) == 0 
                    % create edge p->hole
                    adjMatrix(contextMap(i,j),hole) = Inf;
                else
                    % create edge orig->p
                    adjMatrix(originalImage, contextMap(i,j)) = Inf;
                end
                % test pixel to the right
                if i < w && context(i+1, j) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i+1,j)) = getGradientMagnitude(i,j,i+1,j, lab1, lab2, x_t, y_t);
                elseif i < w && mask(i+1,j) == 0 
                    % create edge p->hole
                    adjMatrix(contextMap(i,j),hole) = Inf;
                else
                    % create edge orig->p
                    adjMatrix(originalImage, contextMap(i,j)) = Inf;
                end
                % test pixel below
                if j < h && context(i, j+1) == 1
                    % create edge p->q
                    adjMatrix(contextMap(i,j),contextMap(i,j+1)) = getGradientMagnitude(i,j,i,j+1, lab1, lab2, x_t, y_t);
                elseif j < h && mask(i,j+1) == 0 
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

