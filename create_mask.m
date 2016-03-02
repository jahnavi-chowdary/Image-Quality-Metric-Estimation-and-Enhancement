% This function computes the mask of a color fundus image
% It requires a threshold.
% Usage :
%   mask = create_mask(img,threshold)
% Where :
%   mask -> Fundus Mask.
%   img  -> Color Fundus image
%   threshold -> Threshold for masking of the fundus.
% Author :  Ujjwal
% Date   :  Some centuries back when the world was a much better place to live in.
% Algorithm : Self-explanatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
function out = create_mask(img,thresh)
% This creates mask for a given image at a given threshold
if numel(size(img))==3
    img = img(:,:,1);
end
img = img < thresh;
img = ~img;
BW = bwconncomp(img);
areas = regionprops(BW,'Area');
areas = [areas.Area];
[~,I] = sort(areas);
I = I(end);
idx = regionprops(BW,'PixelIdxList');
idx = {idx.PixelIdxList};
idx = idx{I};
out = img;
out(setdiff(1:numel(img),idx)) = 0;
out = imfill(out,'holes');