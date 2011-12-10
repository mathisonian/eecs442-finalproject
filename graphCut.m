function [ cutMask ] = graphCut( adjMatrix, contextMap )
    
    % Remove the sink/source info
    adjMatrix = adjMatrix(1:end-2,1:end-2);
    
    normalized = adjMatrix / sum(adjMatrix(:));
    w = size(adjMatrix,1);
    h = size(adjMatrix,2);
    contractPointers = cell(1,w);
    
    while max(normalized(:)) < 1
        normalized = normalized / sum(normalized(:));
        r = rand(1);
        curPosition = 0;
        contracted = 0;
        for i = 1:w
            for j = 1:h
                curPosition = curPosition + normalized(i,j);
                if r < curPosition
                    normalized(i,:) = normalized(i,:) + normalized(j,:);
                    normalized(:,i) = normalized(:,i) + normalized(:,j);
                    normalized(:,j) = zeros(w,1);
                    normalized(j,:) = zeros(1,h);
                    normalized(i,i) = 0;
                    
                    % Store in i that we added j to it
                    contractPointers{i} = [contractPointers{i}, contractPointers{j}, j];
                    contractPointers{j} = [];
                    
                    contracted = 1;
                    break;
                end
            end
            if contracted == 1
                break;
            end
        end
    end
    
    % return a mask of shit that is in the new / old image
    [r,c] = find(contextMap);
    cutMask = zeros(size(contextMap));
    cut=0;
    for i = 1:w
        cur = contractPointers{i};
        if(size(cur,1) > 0)
            cut = cut + 1;
        end
        for pointer = cur
            cutMask(r(pointer), c(pointer)) = cut;
        end
    end
    
    
end

