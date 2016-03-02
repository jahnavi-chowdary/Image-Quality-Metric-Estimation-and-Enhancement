clear;
clc;
close all;

im1 = imread('./Tests/Target1/test1/input.jpg');
% ori = enhancement(im1,10,10,4,1,0,0);
figure; 
imshow(im1);
% title('Original Image');

% ori = im1;

ori = imread('output.jpg');
ori = uint8(ori);
ori_r = ori(:,:,1);
ori_g = ori(:,:,2);
ori_b = ori(:,:,3);

ref = imread('./Tests/Target1/test1/target.jpg');
ref_r = ref(:,:,1);
ref_g = ref(:,:,2);
ref_b = ref(:,:,3);

B_r = imhistmatch(ori_r,ref_r);
B_g = imhistmatch(ori_g,ref_g);
B_b = imhistmatch(ori_b,ref_b);

B = cat(3,B_r,B_g,B_b);

% figure;
% imshow(ref);
% title({'Reference Image to which ','histogram should be matched'})

figure;
imshow(uint8(B));
% title('Matched Image')

% figure;
% imhist(rgb2gray(im1));
% title({'Histogram of ',' Illumination Corrected Image'});

% figure;
% imhist(rgb2gray(ref));
% title({'Histogram of ','Reference Image'});

% figure;
% imhist(rgb2gray(B));
% title({'Histogram of ',' Matched Image'});

final = enhancement(B,10,10,4,1,0,0);

figure; 
imshow(uint8(final));
% title({'Illumination corrected','Image'})

% [X1,y] = imhist(rgb2gray(ref));
% [X2,y1] = imhist(rgb2gray(B));
% D = X1 - X2;
% figure, plot(D)