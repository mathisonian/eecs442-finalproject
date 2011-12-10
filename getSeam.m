function [ ] = getSeam( image )
% Gets the seam thing

    image = rgb2gray(image);
    [gx, gy] = gradient(image);
    
    
    % TODO: Add terminating conditions to this recursive
    %       function.
    function m = M(i,j)
        if i == 0
            m = energy(i,j);
            return;
        end
        m = e(i,j) + min([M(i-1,j-1), M(i-1,j), M(i-1,j+1)]);
    
        function e = energy(i,j)
            e = abs(gx(i,j)) + abs(gy(i,j));
        end
    end

end

