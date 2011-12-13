function [ out ] = solvePoisson2(src,tgt,context,select,xt,yt)

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
    
    %translate source image
    source = zeros(width,height);
    source(xt+1:width,yt+1:height) = src(1:width-xt,1:height-yt);
    
    %sparse matrix
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
    source = conv2(source, -laplacian, 'same');
    
    %iterate through A
    cnt=0;
    for i=2:width-1
        for j=2:height-1
            if(select(i,j)==0 || context(i,j) == 2)
                cnt = cnt + 1;
                A(cnt,cnt) = 4;
                %check for neighbors
                if(select(i,j+1) == 0 || context(i,j+1) == 2)
                    p = c2v(i,j+1);
                    A(cnt, p) = -1;
                else
                    b(cnt) = b(cnt) + tgt(i,j+1);
                end
                
                if(select(i,j-1) == 0 || context(i,j-1) == 2)
                    p = c2v(i,j-1);
                    A(cnt, p) = -1;
                else
                    b(cnt) = b(cnt) + tgt(i,j-1);
                end
                
                if(select(i+1,j) == 0 || context(i+1,j) == 2)
                    p = c2v(i+1,j);
                    A(cnt, p) = -1;
                else
                    b(cnt) = b(cnt) + tgt(i+1,j);
                end
                
                if(select(i-1,j) == 0 || context(i-1,j) == 2)
                    p = c2v(i-1,j);
                    A(cnt, p) = -1;
                else
                    b(cnt) = b(cnt) + tgt(i-1,j);
                end
                %add guidance vector field
                b(cnt) = b(cnt) + source(i,j);
            end
        end
    end
    
    %solve for x
    
    x = A\(b');
    %x = lscov(A,b);
    
    out = tgt;
    
    for i=1:width
        for j=1:height
            if(select(i,j)==0 || context(i,j)==2)
                p = c2v(i,j);
                out(i,j) = x(p);
            end
        end
    end
               
            
end
