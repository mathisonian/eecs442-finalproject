function translation = matchContext(matchimg,inputimg,mask)
%returns the translaion and scale of the best context match
%between matchimg and the original inputimg - removed selection

%pixels within this radius are a part of the input's context
CONTEXT_RADIUS = 80;

%valid scales that can be applied to the match image
VALID_SCALE = ([.81,.90,1]);

%scales the translational error
TRANSLATE_ERROR = 1;

%scales the texture descriptor error
TEXTURE_ERROR = 1;

%read files
match = imread(matchimg);
input = imread(inputimg);
cform = makecform('argb2lab');
insize = size(input);
selection = mask;

%build context matrix
context = zeroes(selection(1),selection(2));

%boundaries of context
c_x = ([-1 -1]);
c_y = ([-1 -1]);

for i=1:insize(1)
    for j=1:insize(2)
        if(selection(i,j)==0)
            for k=max(1,i-CONTEXT_RADIUS):min(i+CONTEXT_RADIUS,insize(1))
                for l=max(1,j-CONTEXT_RADIUS):min(j+CONTEXT_RADIUS,insize(2))
                    d = sqrt((i-k)^2+(j-l)^2);
                    if(d<=CONTEXT_RADIUS && (i~=k && j~=l))
                        context(k,l) = 1;
                        if(c_x(1)==-1 || k<c_x(1))
                            c_x(1)=k;
                        end
                        if(c_x(2)==-1 || k>c_x(2))
                            c_x(2)=k;
                        end
                        if(c_y(1)==-1 || l<c_y(1))
                            c_y(1)=l;
                        end
                        if(c_y(2)==-1 || l>c_y(2))
                            c_y(2)=l;
                        end
                    end
                end
            end
        end
    end
end

%now compute the SSD across all valid translations and scales
%find minimum SSD
minSSD = -1;
for i=VALID_SCALE(1):VALID_SCALE(size(VALID_SCALE))
    scl = imresize(match, i);
    sclsz = size(scl);
    for xt=(c_x(2)-sclsz(1)):(c_x(1)-1)
        for yt=(c_y(2)-sclsz(2)):(c_y(1)-1)
            if((sclsz(1)+xt)>=c_x(2) && (1+xt)<=c_x(1) && (sclsz(2)+yt)>=c_y(2) && (1+yt)<=c_y(2))
                x = getContextSSD(scl,xt,yt,input,context);
                x = x + xt*TRANSLATE_ERROR + yt*TRANSLATE_ERROR;
                x = TEXTURE_ERROR*getContextTFilt(scl,xt,yt,input,context);
                if(minSSD==-1 || x<minSSD)
                    minSSD=x;
                    translation = struct('x_t',xt,'y_t',yt,'sc',i);
                end
            end
        end
    end
end

end

