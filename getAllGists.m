function [out] = getAllGists( indir )
%get gists of all images and save to file
%reads images in all subdirectories as well

d = dir(indir);

for i=3:size(d)
    n = [indir '\' d(i).name];
    if(d(i).isdir)
        getAllGists(n);
    else
        [a,b,c]=fileparts(n);
        if(~strcmp(c,'.gist'))
            img = imread(n);
            gist = getGist(img);
            save([n '.gist'],'gist');
        end
    end
end


end

