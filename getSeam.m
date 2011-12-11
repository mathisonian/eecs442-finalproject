function [ seamMask ] = getSeam( img, isVertical )
% Gets the seam thing

    image = rgb2gray(img);
    [gx, gy] = gradient(double(image));
    
    w = size(image, 2);
    h = size(image, 1);
    
    dpArray = -1.*ones(size(image));
    seamMask = zeros(size(image));
    
    if isVertical == 1
        
        for j=1:w
            M(h,j);    
        end

        % Now do the backtracking!
        [C,I] = min(dpArray(h,:));
        index = I(1);
        img(h,index,:) = [255,0,0];
        seamMask(h,index) = 1;
        for i=h-1:-1:1
            if index == 1
                [C,I] = min(dpArray(i,index:index+1));
                index = (index-1) + I(1);
            elseif index == w
                [C,I] = min(dpArray(i,index-1:index));
                index = (index-2) + I(1);    
            else
                [C,I] = min(dpArray(i,index-1:index+1));
                index = (index-2) + I(1);        
            end
            img(i,index,:) = [255,0,0];
            seamMask(i,index) = 1;
        end
    else
        for i=1:h
            M(i,w);    
        end
        
        % Now do the backtracking!
        [C,I] = min(dpArray(:,w));
        index = I(1);
        img(index,w,:) = [255,0,0];
        seamMask(index,w) = 1;
        for j=w-1:-1:1
            if index == 1
                [C,I] = min(dpArray(index:index+1,j));
                index = (index-1) + I(1);
            elseif index == w
                [C,I] = min(dpArray(index-1:index,j));
                index = (index-2) + I(1);    
            else
                [C,I] = min(dpArray(index-1:index+1,j));
                index = (index-2) + I(1);        
            end
            img(index,j,:) = [255,0,0];
            seamMask(index,j) = 1;
        end
    end
    imshow(img)
    
    % Only works for vertical slicing currently
    function m = M(i,j)
        % end condition for vertical
        if (isVertical == 1 && i == 0) || (isVertical == 0 && j == 0)
            m = 0;
            return;
        end
        % Force staying within bounds of the image
        if (isVertical == 1 && (j < 1 || j > w)) || (isVertical == 0 && (i < 1 || i > h))
            m = Inf;
            return;
        end
        % Dynamic programming via horribly scoped variables!
        % ;)
        if dpArray(i,j) ~= -1
            m = dpArray(i,j);
            return;
        end
        
        if isVertical == 1
            m = energy(i,j) + min([M(i-1,j-1), M(i-1,j), M(i-1,j+1)]);
        else
            m = energy(i,j) + min([M(i-1,j-1), M(i,j-1), M(i+1,j-1)]);
        end
        dpArray(i,j) = m;
        
        function e = energy(i,j)
            e = abs(gx(i,j)) + abs(gy(i,j));
        end
    end

end

