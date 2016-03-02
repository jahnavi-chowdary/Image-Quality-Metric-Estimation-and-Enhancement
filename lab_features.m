function [targetvect] = lab_features(im1,ref)
targervect = [];

ori = rgb2lab(im1);
ori_l = ori(:,:,1);
ori_a = ori(:,:,2);
ori_b = ori(:,:,3);

ori_l = ori_l./100;
ori_a = (ori_a + 86.185) ./ 184.439;
ori_b = (ori_b + 107.863) ./ 202.345;

ori_l_hist = imhist(ori_l);
ori_a_hist = imhist(ori_a);
ori_b_hist = imhist(ori_b);

ref = rgb2lab(ref);
ref_l = ref(:,:,1);
ref_a = ref(:,:,2);
ref_b = ref(:,:,3);

ref_l = ref_l./100;
ref_a = (ref_a + 86.185) ./ 184.439;
ref_b = (ref_b + 107.863) ./ 202.345;

B_l = imhistmatch(ori_l,ref_l);
B_a = imhistmatch(ori_a,ref_a);
B_b = imhistmatch(ori_b,ref_b);

B_l = B_l./100;
B_a = (B_a + 86.185) ./ 184.439;
B_b = (B_b + 107.863) ./ 202.345;

B_l_hist = imhist(B_l);
B_a_hist = imhist(B_a);
B_b_hist = imhist(B_b);

% Difference 

L_diffm = mean2(abs(B_l_hist - ori_l_hist));
A_diffm = mean2(abs(B_a_hist - ori_a_hist));
B_diffm = mean2(abs(B_b_hist - ori_b_hist));

L_diffv = (std2(abs(B_l_hist - ori_l_hist)))^2;
A_diffv = (std2(abs(B_a_hist - ori_a_hist)))^2;
B_diffv = (std2(abs(B_b_hist - ori_b_hist)))^2;

L_diff = abs(B_l_hist - ori_l_hist);
A_diff = abs(B_a_hist - ori_a_hist);
B_diff = abs(B_b_hist - ori_b_hist);

L_diffs = skewness(L_diff(:));
A_diffs = skewness(A_diff(:));
B_diffs = skewness(B_diff(:));

L_diffk = kurtosis(L_diff(:));
A_diffk = kurtosis(A_diff(:));
B_diffk = kurtosis(B_diff(:));

% targetvect = [targetvect;R_diff];
% targetvect = [targetvect;G_diff];
% targetvect = [targetvect;B_diff];

targetvect = [L_diffm; A_diffm; B_diffm; L_diffv; A_diffv; B_diffv; L_diffs; A_diffs; B_diffs; L_diffk; A_diffk; B_diffk ];

end