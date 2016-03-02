% This function extends the fundus region of a retinal image in the non-fundus surround.
% This helps in avoiding any artifacts which might arise out of a sharp gradient at the 
% fundus boundary or due to the high contrast between the fundus and non-fundus regions.
% Usage :
%  img_extended = extension(img,mask)
% Where :
%   img_extended -> Output extended image
%   img -> Color fundus image 
%   mask -> Fundus Mask
%   Author : Ujjwal
%   Date : 22 August, 2014
% Algorithm :
% For each non-fundus pixel, find the most proximate point on the fundus boundary. Now,
% reflect the pixel on the other side of the boundary onto this pixel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function img = extension(img,mask)
tic;
mask = imerode(mask,strel('disk',20));
boundary = mask & ~imerode(mask,strel('disk',1));
temp1 = zeros(size(mask));
temp2 = zeros(size(mask));
temp3 = zeros(size(mask));
[row_b,col_b] = find(boundary);
mask_eroded = imerode(mask,strel('disk',1));
[row_bg,col_bg] = find(~mask);
idx = knnsearch([row_b,col_b],[row_bg,col_bg]);
for i = 1 : length(row_bg)
    try
	    img(row_bg(i),col_bg(i),:) = img(2*row_b(idx(i)) - row_bg(i), 2 *col_b(idx(i)) - col_bg(i),:);
    catch ME
	    if strcmp(ME.identifier,'MATLAB:badsubscript')
	       fprintf(1,'There was a subscript problem.\n');
	       fprintf(1,'Size of image is %d by %d by %d\n',size(img,1),size(img,2),size(img,3));
	       fprintf(1,'statement was img(%d,%d,:) = img(%d,%d,:)\n',row_bg(i),col_bg(i),2*row_b(idx(i))-row_bg(i),2*col_b(idx(i))-col_bg(i));
	       img = 1; 
	       return;
	    else
		rethrow(ME)
	    end
   end
			
end