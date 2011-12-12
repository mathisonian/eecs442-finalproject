function SSD = getContextSSD(m_l,xt,yt,i_l,context)
%return sum of squared differences of context
SSD=0;

sz = size(i_l);
for i=1:sz(1)
    for j=1:sz(2)
        if(context(i,j)==1)
            sd = double((i_l(i,j,1)-m_l(i-xt,j-yt,1)))^2;
            sd = sd + double((i_l(i,j,2)-m_l(i-xt,j-yt,2)))^2;
            sd = sd + double((i_l(i,j,3)-m_l(i-xt,j-yt,3)))^2;
            SSD = SSD + sd;
        end
    end
end
end

