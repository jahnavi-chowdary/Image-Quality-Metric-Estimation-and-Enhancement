% function il2 = nui_right(im)
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
B(id) = 1;

fil = fspecial('gaussian',[1000 1000],500);
imf1 = imfilter(B, fil);

% figure; imshow(imf1);

imf1 = imcrop(imf1,[0 0 2196 1958]);
I3 = flipdim(imf1 ,2);
I3 = flipdim(I3 ,1);
imf = I3;
imff = (0.3) * double(imf);
figure; imshow(imff);

il = double(zeros(size(im)));
i = rgb2ycbcr(im);
il(:,:,1) = double(i(:,:,1)) + (0.3) * double(imf);
il(:,:,2) = double(i(:,:,2));
il(:,:,3) = double(i(:,:,3));

il2 = ycbcr2rgb((il));
figure, imshow(il2)
figure; imshow(im);

% end