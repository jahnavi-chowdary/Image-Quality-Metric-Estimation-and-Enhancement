function [ldrift cdrift]= LumConDrift(bgImg,fundusMask)

[m n]=size(bgImg);

tsize= 200;

indx=1;
indy=1;
ldrift=zeros(2,2);
cdrift=zeros(2,2);
for i=tsize+1:tsize:m
    for j=tsize+1:tsize:n
        if i+tsize>=m && j+tsize<n
            block= bgImg(i-tsize:end, j-tsize:j+tsize);
        else if i+tsize<m && j+tsize>=n
                block= bgImg(i-tsize:i+tsize, j-tsize:end);
            else if i+tsize>=m && j+tsize>=n
                    block= bgImg(i-tsize:end, j-tsize:end);
                else
                    block= bgImg(i-tsize:i+tsize, j-tsize:j+tsize);
                end
            end
        end

        ldrift(indx,indy)= mean2(block);
        %ldrift(indx,indy)= meannnz(block);
        %cdrift(indx,indy)= stdnnz(block);
        cdrift(indx,indy)= std2(block);
        indy=indy+1;

    end
    indy=1;
    indx=indx+1;
end

ldrift=imresize(ldrift,[m n], 'bicubic');
cdrift=imresize(cdrift,[m n],'bicubic');

ldrift=immultiply(ldrift, fundusMask);
cdrift=immultiply(cdrift, fundusMask);
