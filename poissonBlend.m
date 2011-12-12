function [ finalimg ] = poissonBlend(img,context,selection)

%solve independently for each color channel

%find edges of context, denote by '3'
for i=1:size(context,1)
    for j=1:size(context,2)
        if(context(i,j)==1)
            if(context(i,j+1)==2 || context(i,j-1)==2 || context(i+1,j)==2 || context(i-1,j)==2)
                context(i,j)=3;
            end
        end
    end
end

img(:,:,1) = solvePoisson(img(:,:,1),context,selection);
img(:,:,2) = solvePoisson(img(:,:,2),context,selection);
img(:,:,3) = solvePoisson(img(:,:,3),context,selection);

finalimg = img;

end

