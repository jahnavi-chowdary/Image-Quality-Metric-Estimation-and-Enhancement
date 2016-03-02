function [mean_val, var_val] = get_meanvar(img,pts,winsize)
if numel(size(img))==3
    img = img(:,:,2);
end
sz = size(img);
mean_val = zeros(1,size(pts,1));
var_val = zeros(size(mean_val));
for i= 1 : size(pts,1)
    R = pts(i,2);
    C = pts(i,1);
    if (R-winsize)<1
        row_min = 1;
    else
        row_min = R - winsize;
    end

    if (R + winsize) > sz(1)
        row_max = sz(1);
    else
        row_max = R + winsize;
    end

    if (C - winsize)<1
        col_min = 1;
    else
        col_min = C - winsize;
    end

    if (C + winsize)> sz(2)
        col_max = sz(2);
    else
        col_max = C + winsize;
    end
    patch = img(row_min:row_max,col_min:col_max);
    mean_val(i) = mean((patch(:)));
    var_val(i) = sqrt(var(single((patch(:)))));
end