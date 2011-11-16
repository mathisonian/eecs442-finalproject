function [ sum ] = getColorDiff( img1, img2 )

    sum = 0;
    cform = makecform('srgb2lab');
    lab1 = applycform(img1,cform);
    lab2 = applycform(img2,cform);
    
    s = size(lab1);
    w = s(1);
    h = s(2);
    
    for i = 1 : w
        for j = 1 : h
            sum = sum + ((lab1(i,j,1)-lab2(i,j,1))^2 + (lab1(i,j,2)-lab2(i,j,2))^2 + (lab1(i,j,3)-lab2(i,j,3))^2 );
        end
    end
    
end

