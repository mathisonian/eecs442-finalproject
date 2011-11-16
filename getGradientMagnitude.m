function [ F ] = getGradientMagnitude( x1,y1,x2,y2,img1,img2 )

    cform = makecform('srgb2lab');
    lab1 = applycform(img1,cform);
    lab2 = applycform(img2,cform);
    
    d1 = (lab1(x1,y1,1)-lab2(x1,y1,1))^2 + (lab1(x1,y1,2)-lab2(x1,y1,2))^2 + (lab1(x1,y1,3)-lab2(x1,y1,3))^2;
    d2 = (lab1(x2,y2,1)-lab2(x2,y2,1))^2 + (lab1(x2,y2,2)-lab2(x2,y2,2))^2 + (lab1(x2,y2,3)-lab2(x2,y2,3))^2;
    
    F = gradient([d1, d2]);

end

