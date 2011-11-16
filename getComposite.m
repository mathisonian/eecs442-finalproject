function img = getComposite(matchimg, inputimg, xt, yt, scale, context, select)
%create composite of input image and translated match image
match = imread(matchimg);
match = imresize(match, scale);
input = imread(inputimg);
insize = size(input);
img = input;
%TEST
%fill in entire context + select area with match image



for i=1:insize(1)
    for j=1:insize(2)
        if(select(i,j)==0 || context(i,j)==1)
            img(i,j,1)=match(i-xt,j-yt,1);
            img(i,j,2)=match(i-xt,j-yt,2);
            img(i,j,3)=match(i-xt,j-yt,3);
        end
    end
end
imshow(img);
end

