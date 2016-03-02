% function il2 = nui_angle(im)

close all
im = imread('input.jpg');
im = im2double(im);
nx = size(im,1); ny = size(im,2);

x = linspace(-1,1,nx); %defines the range
y = linspace(-1,1,ny);

[X,Y] = ndgrid(x,y); %creates two 2-D arrays of x and y coordinates

r = sqrt(X.^2 + Y.^2); 

B = zeros(nx+1500,ny+1500);
id = find(r<0.7);
B (id) = 1;

fil = fspecial('gaussian',[1000 1000],500);

imf1 = imfilter(B, fil);

B1 = imrotate(imf1,240);
% figure, imshow(B1) 
imf1 = imfilter(B1, fil);

% figure; imshow(imf1);

imf2 = imcrop(imf1,[500 500 2195 1957]);

imf = imf2;
imff = (0.5) * double(imf);
figure; imshow(imff);
% imshow(I3)
% I3 = flipdim(imf ,2);
% imf = I3;

il = double(zeros(size(im)));
i = rgb2ycbcr(im);
il(:,:,1) = double(i(:,:,1)) + (0.5) * double(imf);
il(:,:,2) = double(i(:,:,2));
il(:,:,3) = double(i(:,:,3));

il2 = ycbcr2rgb((il));
% imshow(il2);
figure, imshow(il2)
figure; imshow(im);

% end