function [ sum ] = getSSD( v1, v2 )
    sum=0;
    n = size(v1,1);
    for i = 1 : n
       sum = sum + (v1(i,1) - v2(i,1))^2; 
    end
    
end

