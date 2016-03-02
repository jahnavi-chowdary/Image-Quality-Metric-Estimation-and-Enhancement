function [bgImg, fundusMask]= computebgimg(im)

[h, s, v]=rgb2hsv(im);

%fundusMask=v>0.01;
fundusMask=v>0.05;

g=im(:,:,2); %green channel

[m, n]=size(g);

tsize=50;

indx=1;
indy=1;

tmean=zeros(2,2);
tstd=zeros(2,2);

for i=tsize+1:tsize:m
    for j=tsize+1:tsize:n
        
        if i+tsize>=m && j+tsize<n
            block= g(i-tsize:end, j-tsize:j+tsize);
        
        else if i+tsize<m && j+tsize>=n
                block= g(i-tsize:i+tsize, j-tsize:end);
            else if i+tsize>=m && j+tsize>=n
                    block= g(i-tsize:end, j-tsize:end);
                else
                    block = g(i-tsize:i+tsize, j-tsize:j+tsize);
                end
            end
        end

        tmean(indx,indy)= mean2(block);
        tstd(indx,indy)= std2(block);
        indy=indy+1;
        
    end
    indy=1;
    indx=indx+1;
end

tmean=imresize(tmean,[m n], 'bicubic');
tstd=imresize(tstd,[m n],'bicubic');

% imshow(uint8(tmean));

bgImg= abs((double(g)-tmean)./(tstd+0.0001));
bgImg = bgImg < 1;
