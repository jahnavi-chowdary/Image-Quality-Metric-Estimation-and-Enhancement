function [targetvect] = rgb_features(im1,ref)
targervect = [];

ori = im1;
ori_r = ori(:,:,1);
ori_g = ori(:,:,2);
ori_b = ori(:,:,3);

ori_r_hist = imhist(ori_r);
ori_g_hist = imhist(ori_g);
ori_b_hist = imhist(ori_b);

% ref = ref
ref_r = ref(:,:,1);
ref_g = ref(:,:,2);
ref_b = ref(:,:,3);

B_r = imhistmatch(ori_r,ref_r);
B_g = imhistmatch(ori_g,ref_g);
B_b = imhistmatch(ori_b,ref_b);

B_r_hist = imhist(B_r);
B_g_hist = imhist(B_g);
B_b_hist = imhist(B_b);

% Difference 

R_diffm = mean2(abs(B_r_hist - ori_r_hist));
G_diffm = mean2(abs(B_g_hist - ori_g_hist));
B_diffm = mean2(abs(B_b_hist - ori_b_hist));

R_diffv = (std2(abs(B_r_hist - ori_r_hist)))^2;
G_diffv = (std2(abs(B_g_hist - ori_g_hist)))^2;
B_diffv = (std2(abs(B_b_hist - ori_b_hist)))^2;

R_diff = abs(B_r_hist - ori_r_hist);
G_diff = abs(B_g_hist - ori_g_hist);
B_diff = abs(B_b_hist - ori_b_hist);

R_diffs = skewness(R_diff(:));
G_diffs = skewness(G_diff(:));
B_diffs = skewness(B_diff(:));

R_diffk = kurtosis(R_diff(:));
G_diffk = kurtosis(G_diff(:));
B_diffk = kurtosis(B_diff(:));

targetvect = [R_diffm; G_diffm; B_diffm; R_diffv; G_diffv; B_diffv; R_diffs; G_diffs; B_diffs; R_diffk; G_diffk; B_diffk ];

end