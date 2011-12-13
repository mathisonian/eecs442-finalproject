function [ F ] = getGradientMagnitude( x1,y1,x2,y2,lab1,lab2,x_t,y_t)
       
    d1 = (lab1(x1,y1,1)-lab2(x1-x_t,y1-y_t,1))^2 + (lab1(x1,y1,2)-lab2(x1-x_t,y1-y_t,2))^2 + (lab1(x1,y1,3)-lab2(x1-x_t,y1-y_t,3))^2;
    d2 = (lab1(x2,y2,1)-lab2(x2-x_t,y2-y_t,1))^2 + (lab1(x2,y2,2)-lab2(x2-x_t,y2-y_t,2))^2 + (lab1(x2,y2,3)-lab2(x2-x_t,y2-y_t,3))^2;
    
    F = gradient([d1, d2]);
    F = F(1)*F(1) + F(2)*F(2);

end

