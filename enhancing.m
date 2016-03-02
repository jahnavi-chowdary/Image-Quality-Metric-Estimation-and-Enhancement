clc;
clear all;
close all;

im1 = imread('(00000061).jpg');
enh = enhancement(im1,10,10,4,1,0,0);
figure;
subplot(121), imshow(im1)
title('Original Image');
subplot(122), imshow(enh)
title({'Illumination corrected','Image'})