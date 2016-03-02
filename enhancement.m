function [im]=enhancement(im, rmin, numrings, minpoints, sampling, flip, output)

hsv = rgb2hsv(im); % Convert to HSV for color correction

if (sampling==1) %use non uniform sampling
    [bgImg, fundusMask, pointplot]=computebgimgnur(im, rmin, numrings, minpoints, flip);
    %[bgImg, fundusMask, pointplot]=equal(im, rmin, numrings);
elseif (sampling==0)
    [bgImg, fundusMask]=computebgimg(im);
end

disp 'Background Image has been computed ... :)'

bgImg=immultiply(im2double(im(:,:,2)),bgImg); % To deal with the non-fundus area

[ldrift, cdrift]= LumConDrift(bgImg,fundusMask); % Compute the illumination and contrast component (Fig 6) 

disp 'luminsity and contrast drift has been computed .. :)'

g=im2double(im(:,:,2));

%% Image normalisation using computed Luminsity and Contrast drifts
imgCorr = (g-ldrift)./(cdrift+.0001); % Equation 2 
imgCorr = immultiply(imgCorr,fundusMask);

%imshow(imgCorr);

disp 'Image correction is applied .. :)'

%% Image adjustment for a good View

if min(min(imgCorr))<0
    %a=min(min(imgCorr));
    %disp(a);
    
    %b=max(max(imgCorr));
    %disp(b);
    imgCorr= imgCorr + abs(min(min(imgCorr))); % This and the next 2 lines do image normalizatin and fundus mask multiplication
end

%imshow(imgCorr);

imgCorr= imgCorr./(max(max(imgCorr)));
%b=max(max(imgCorr));
%disp(b);

%imshow(imgCorr);
%imgCorr=histeq(imgCorr);

imgCorr= immultiply(imgCorr,fundusMask);

%imshow(imgCorr);

%a=min(min(imgCorr));
 %   disp(a);
%b=max(max(imgCorr));
%disp(b);

%% IMAGE NORMLISATION ON COLOR VERSION OF THE IMAGE


im = double(im); % Convert to double to avoid any error message
% Final logic for ICVGIP
im(:,:,1)= (imgCorr.* im(:,:,1))./hsv(:,:,3); % Individual color channel correction. This is done to maintain the faithfulness of color 
im(:,:,2)= (imgCorr.* im(:,:,2))./hsv(:,:,3);
im(:,:,3)= (imgCorr.* im(:,:,3))./hsv(:,:,3);
% final= hsv2rgb(hsv);

% %% Grison one
% im(:,:,1)= (rCorr.* rst)+rmean;
% im(:,:,2)= (gCorr.* gst)+gmean;
% im(:,:,3)= (bCorr.* bst)+bmean;

im(:,:,1)=immultiply(im(:,:,1),fundusMask); % finally multiply by the fundus mask
im(:,:,2)=immultiply(im(:,:,2),fundusMask);
im(:,:,3)=immultiply(im(:,:,3),fundusMask);

% figure;
imshow(uint8(im));

if (output==1)
    figure(2);
    imshow(pointplot);
end