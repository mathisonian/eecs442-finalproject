function [ finalimg ] = poissonBlend( matchimg,inputimg,selection,translation )

%solve independently for each color channel

inputimg(:,:,1) = solvePoisson(matchimg(:,:,1),inputimg(:,:,1),selection,translation);
inputimg(:,:,2) = solvePoisson(matchimg(:,:,2),inputimg(:,:,2),selection,translation);
inputimg(:,:,3) = solvePoisson(matchimg(:,:,3),inputimg(:,:,3),selection,translation);

end

