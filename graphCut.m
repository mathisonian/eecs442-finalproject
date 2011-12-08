function [ cutMask ] = graphCut( adjMatrix )
    
    normalized = adjMatrix / sum(adjMatrix(:));
    w = size(adjMatrix,1);
    h = size(adjMatrix,h);
    
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
    
end

