function SSD = getContextTFilt(m_l,xt,yt,i_l,context)
%compute texture filter and ssd
SSD = 0;
%median filter size
FILT_SIZE = 5;

%match = medfilt2(match, [FILT_SIZE FILT_SIZE]);
%input = medfilt2(input, [FILT_SIZE FILT_SIZE]);

m_l(:,:,1) = medfilt2(m_l(:,:,1), [FILT_SIZE FILT_SIZE]);
m_l(:,:,2) = medfilt2(m_l(:,:,2), [FILT_SIZE FILT_SIZE]);
m_l(:,:,3) = medfilt2(m_l(:,:,3), [FILT_SIZE FILT_SIZE]);

i_l(:,:,1) = medfilt2(i_l(:,:,1), [FILT_SIZE FILT_SIZE]);
i_l(:,:,2) = medfilt2(i_l(:,:,2), [FILT_SIZE FILT_SIZE]);
i_l(:,:,3) = medfilt2(i_l(:,:,3), [FILT_SIZE FILT_SIZE]);

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

