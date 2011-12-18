function [ out ] = solvePoisson2(hotfix,src,tgt,context,select,xt,yt)

    %laplacian operator
    laplacian = [0 1 0; 1 -4 1; 0 1 0];
    
    %get size of target image
    [width height] = size(tgt);
    
    %scan through image...
    %if the pixel is in the context:
    %     coordinate to value
    %     and count pixels in context
    %else if the pixel is on the edge of the context:
    %     get average pixel values of edge target pixels
    %     fixes 'bleeding' problem
    N=0;
    c2v = zeros(width,height);
    cnt=0;
    pav = 0;
    edgepixels=0;
    edgefound = 0;
    for i=1:width
        for j=1:height
            if(select(i,j)==0 || context(i,j)==2)
                cnt = cnt+1;
                c2v(i,j) = cnt;
                N = N+1;
            elseif(hotfix==1)
                edgefound = 0;
                if(j<height)
                    if(select(i,j+1) == 0 || context(i,j+1) == 2)
                        if(edgefound == 0)
                            pav = pav+tgt(i,j);
                            edgepixels = edgepixels + 1;
                            edgefound = 1;
                        end
                    end
                end
                if(j>1)
                    if(select(i,j-1) == 0 || context(i,j-1) == 2)
                        if(edgefound == 0)
                            pav = pav+tgt(i,j);
                            edgepixels = edgepixels + 1;
                            edgefound = 1;
                        end
                    end
                end
                if(i<width)
                    if(select(i+1,j) == 0 || context(i+1,j) == 2)
                        if(edgefound == 0)
                            pav = pav+tgt(i,j);
                            edgepixels = edgepixels + 1;
                            edgefound = 1;
                        end
                    end
                end
                if(i>1)
                    if(select(i-1,j) == 0 || context(i-1,j) == 2)
                        if(edgefound == 0)
                            pav = pav+tgt(i,j);
                            edgepixels = edgepixels + 1;
                        end
                    end
                end
            end
        end
    end
    if(hotfix==1)
        pav = pav/edgepixels;
    end
    
    %allocate sparse matrix
    A = spalloc(N,N,5*N);
    %boundary conditions
    b = zeros(1,N);
    
    %apply laplacian operator
    src = conv2(double(src), -laplacian, 'same');
    
    %iterate through A
    cnt=0;
    for i=1:width
        for j=1:height
            if(select(i,j)==0 || context(i,j) == 2)
                cnt = cnt + 1;
                A(cnt,cnt) = 4;
                %check for neighbors
                if(j<height)
                    if(select(i,j+1) == 0 || context(i,j+1) == 2)
                        p = c2v(i,j+1);
                        A(cnt, p) = -1;
                    else
                        b(cnt) = b(cnt) + tgt(i,j+1);
                    end
                else
                    if(hotfix==1)
                        b(cnt) = b(cnt) + pav;
                    elseif(hotfix==0)
                        b(cnt) = b(cnt) + tgt(i,j);
                    end
                end
                if(j>1)
                    if(select(i,j-1) == 0 || context(i,j-1) == 2)
                        p = c2v(i,j-1);
                        A(cnt, p) = -1;
                    else
                        b(cnt) = b(cnt) + tgt(i,j-1);
                    end
                else
                    if(hotfix==1)
                        b(cnt) = b(cnt) + pav;
                    elseif(hotfix==0)
                        b(cnt) = b(cnt) + tgt(i,j);
                    end
                end
                if(i<width)
                    if(select(i+1,j) == 0 || context(i+1,j) == 2)
                        p = c2v(i+1,j);
                        A(cnt, p) = -1;
                    else
                        b(cnt) = b(cnt) + tgt(i+1,j);
                    end
                else
                    if(hotfix==1)
                        b(cnt) = b(cnt) + pav;
                    elseif(hotfix==0)
                        b(cnt) = b(cnt) + tgt(i,j);
                    end
                end
                if(i>1)
                    if(select(i-1,j) == 0 || context(i-1,j) == 2)
                        p = c2v(i-1,j);
                        A(cnt, p) = -1;
                    else
                        b(cnt) = b(cnt) + tgt(i-1,j);
                    end
                else
                    if(hotfix==1)
                        b(cnt) = b(cnt) + pav;
                    elseif(hotfix==0)
                        b(cnt) = b(cnt) + tgt(i,j);
                    end
                end
                %add guidance vector field
                b(cnt) = b(cnt) + src(i-xt,j-yt);
                
            end
        end
    end
    
    %solve for x
    
    x = A\(b');
    %x = pinv(A)*(b');
    %x = lscov(A,b);
    
    %x = bicg(A, b', [], 400);
    
    out = tgt;
    %build output image
    for i=1:width
        for j=1:height
            if(select(i,j)==0 || context(i,j)==2)
                p = c2v(i,j);
                out(i,j) = x(p);
            end
        end
    end
               
            
end

