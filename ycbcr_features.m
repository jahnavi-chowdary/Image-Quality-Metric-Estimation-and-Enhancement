function [targetvect] = ycbcr_features(im1,ref)
targervect = [];

ori = rgb2ycbcr(im1);
ori_y = ori(:,:,1);
ori_cb = ori(:,:,2);
ori_cr = ori(:,:,3);

ori_y_hist = imhist(ori_y);
ori_cb_hist = imhist(ori_cb);
ori_cr_hist = imhist(ori_cr);

ref = rgb2ycbcr(ref);
ref_y = ref(:,:,1);
ref_cb = ref(:,:,2);
ref_cr = ref(:,:,3);

B_y = imhistmatch(ori_y,ref_y);
B_cb = imhistmatch(ori_cb,ref_cb);
B_cr = imhistmatch(ori_cr,ref_cr);

B_y_hist = imhist(B_y);
B_cb_hist = imhist(B_cb);
B_cr_hist = imhist(B_cr);

% Difference 

Y_diffm = mean2(abs(B_y_hist - ori_y_hist));
Cb_diffm = mean2(abs(B_cb_hist - ori_cb_hist));
Cr_diffm = mean2(abs(B_cr_hist - ori_cr_hist));

Y_diffv = (std2(abs(B_y_hist - ori_y_hist)))^2;
Cb_diffv = (std2(abs(B_cb_hist - ori_cb_hist)))^2;
Cr_diffv = (std2(abs(B_cr_hist - ori_cr_hist)))^2;

Y_diff = abs(B_y_hist - ori_y_hist);
Cb_diff = abs(B_cb_hist - ori_cb_hist);
Cr_diff = abs(B_cr_hist - ori_cr_hist);

Y_diffs = skewness(Y_diff(:));
Cb_diffs = skewness(Cb_diff(:));
Cr_diffs = skewness(Cr_diff(:));

Y_diffk = kurtosis(Y_diff(:));
Cb_diffk = kurtosis(Cb_diff(:));
Cr_diffk = kurtosis(Cr_diff(:));

targetvect = [Y_diffm; Cb_diffm; Cr_diffm; Y_diffv; Cb_diffv; Cr_diffv; Y_diffs; Cb_diffs; Cr_diffs; Y_diffk; Cb_diffk; Cr_diffk ];

end