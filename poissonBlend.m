function [ finalimg ] = poissonBlend(source,target,context,selection,x,y)

%solve independently for each color channel

%bleeding hotfix method:
%1 = Edge Average Method
%0 = Copy Target Edge Method
HOTFIX = 0;

f1 = solvePoisson2(HOTFIX,source(:,:,1),target(:,:,1),context,selection,x,y);
f2 = solvePoisson2(HOTFIX,source(:,:,2),target(:,:,2),context,selection,x,y);
f3 = solvePoisson2(HOTFIX,source(:,:,3),target(:,:,3),context,selection,x,y);

[x y z] = size(target);

finalimg = zeros(x,y,3);

finalimg(:,:,1) = f1;
finalimg(:,:,2) = f2;
finalimg(:,:,3) = f3;

end

