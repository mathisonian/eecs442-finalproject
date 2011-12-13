function [ out ] = solvePoisson2(src,tgt,context,select,xt,yt)

    %laplacian operator
    laplacian = [0 1 0; 1 -4 1; 0 1 0];
    
    [width height] = size(tgt);
    
    %number of pixels in source
    N = 0;
    for i=1:width
        for j=1:height
            if(select(i,j)==0)
                N = N+1;
            elseif(context(i,j)==2)
                N = N+1;
            end
        end
    end
    
    %allocate sparse matrix
    A = spalloc(N,N,5*N);
    %boundary conditions
    b = zeros(1,N);
    
    %coordinate to value
    c2v = zeros(width,height);
    cnt=0;
    for i=1:width
        for j=1:height
            if(select(i,j)==0 || context(i,j)==2)
                cnt = cnt+1;
                c2v(i,j) = cnt;
            end
        end
    end
    
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
                end
                if(j>1)
                if(select(i,j-1) == 0 || context(i,j-1) == 2)
                    p = c2v(i,j-1);
                    A(cnt, p) = -1;
                else
                    b(cnt) = b(cnt) + tgt(i,j-1);
                end
                end
                if(i<width)
                if(select(i+1,j) == 0 || context(i+1,j) == 2)
                    p = c2v(i+1,j);
                    A(cnt, p) = -1;
                else
                    b(cnt) = b(cnt) + tgt(i+1,j);
                end
                end
                if(i>1)
                if(select(i-1,j) == 0 || context(i-1,j) == 2)
                    p = c2v(i-1,j);
                    A(cnt, p) = -1;
                else
                    b(cnt) = b(cnt) + tgt(i-1,j);
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

