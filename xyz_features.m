function [targetvect] = xyz_features(im1,ref)

targetvect = [];

ori = rgb2xyz(im1);
ori_x =ori(:,:,1);
ori_y = ori(:,:,2);
ori_z = ori(:,:,3);

ori_x_hist = imhist(ori_x);
ori_y_hist = imhist(ori_y);
ori_z_hist = imhist(ori_z);

ref = rgb2xyz(ref);
ref_x = ref(:,:,1);
ref_y = ref(:,:,2);
ref_z = ref(:,:,3);

B_x = double(imhistmatch(ori_x,ref_x));
B_y = double(imhistmatch(ori_y,ref_y));
B_z = double(imhistmatch(ori_z,ref_z));

B_x_hist = imhist(B_x);
B_y_hist = imhist(B_y);
B_z_hist = imhist(B_z);

% Difference 

X_diffm = mean2(abs(B_x_hist - ori_x_hist));
Y_diffm = mean2(abs(B_y_hist - ori_y_hist));
Z_diffm = mean2(abs(B_z_hist - ori_z_hist));

X_diffv = (std2(abs(B_x_hist - ori_x_hist)))^2;
Y_diffv = (std2(abs(B_y_hist - ori_y_hist)))^2;
Z_diffv = (std2(abs(B_z_hist - ori_z_hist)))^2;

X_diff = abs(B_x_hist - ori_x_hist);
Y_diff = abs(B_y_hist - ori_y_hist);
Z_diff = abs(B_z_hist - ori_z_hist);

X_diffs = skewness(X_diff(:));
Y_diffs = skewness(Y_diff(:));
Z_diffs = skewness(Z_diff(:));

X_diffk = kurtosis(X_diff(:));
Y_diffk = kurtosis(Y_diff(:));
Z_diffk = kurtosis(Z_diff(:));

targetvect = [X_diffm; Y_diffm; Z_diffm; X_diffv; Y_diffv; Z_diffv; X_diffs; Y_diffs; Z_diffs; X_diffk; Y_diffk; Z_diffk ];

end