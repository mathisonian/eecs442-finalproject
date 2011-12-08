function [ cutMask ] = graphCut( adjMatrix )
    
    normalized = adjMatrix / sum(adjMatrix(:));
    w = size(adjMatrix,1);
    h = size(adjMatrix,h);
    
    while % there are edges left to contract
        normalized = normalized / sum(normalized(:));
        r = rand(1);
        curPosition = 0;
        for i = 1:w
            for j = 1:h
                curPosition = curPosition + normalized(i,j);
                if r < curPosition
                    % WE HAVE FOUND THE RANDOMLY SELECTED EDGE
                    % contract this shit and do it again
                    break;
                end
            end
        end
    end
    
    % return a mask of shit that is in the new / old image
    
end

