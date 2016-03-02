function [targetvect] = hsv_features(im1,ref)

targetvect = [];

ori = rgb2hsv(im1);
ori_h = ori(:,:,1);
ori_s = ori(:,:,2);
ori_v = ori(:,:,3);

ori_h_hist = imhist(ori_h);
ori_s_hist = imhist(ori_s);
ori_v_hist = imhist(ori_v);

ref = rgb2hsv(ref);
ref_h = ref(:,:,1);
ref_s = ref(:,:,2);
ref_v = ref(:,:,3);

B_h = imhistmatch(ori_h,ref_h);
B_s = imhistmatch(ori_s,ref_s);
B_v = imhistmatch(ori_v,ref_v);

B_h_hist = imhist(B_h);
B_s_hist = imhist(B_s);
B_v_hist = imhist(B_v);

% Difference 

H_diffm = mean2(abs(B_h_hist - ori_h_hist));
S_diffm = mean2(abs(B_s_hist - ori_s_hist));
V_diffm = mean2(abs(B_v_hist - ori_v_hist));

H_diffv = (std2(abs(B_h_hist - ori_h_hist)))^2;
S_diffv = (std2(abs(B_s_hist - ori_s_hist)))^2;
V_diffv = (std2(abs(B_v_hist - ori_v_hist)))^2;

H_diff = abs(B_h_hist - ori_h_hist);
S_diff = abs(B_s_hist - ori_s_hist);
V_diff = abs(B_v_hist - ori_v_hist);

H_diffs = skewness(H_diff(:));
S_diffs = skewness(S_diff(:));
V_diffs = skewness(V_diff(:));

H_diffk = kurtosis(H_diff(:));
S_diffk = kurtosis(S_diff(:));
V_diffk = kurtosis(V_diff(:));

targetvect = [H_diffm; S_diffm; V_diffm; H_diffv; S_diffv; V_diffv; H_diffs; S_diffs; V_diffs; H_diffk; S_diffk; V_diffk ];

end