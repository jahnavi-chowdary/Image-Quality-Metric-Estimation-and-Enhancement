function [targetvect] = yiq_features(im1,ref);

targetvect = [];

ori = rgb2ntsc(im1);
ori_y = ori(:,:,1);
ori_i = ori(:,:,2);
ori_q = ori(:,:,3);

ori_y_hist = imhist(ori_y);
ori_i_hist = imhist(ori_i);
ori_q_hist = imhist(ori_q);

ref = rgb2ntsc(ref);
ref_y = ref(:,:,1);
ref_i = ref(:,:,2);
ref_q = ref(:,:,3);

B_y = imhistmatch(ori_y,ref_y);
B_i = imhistmatch(ori_i,ref_i);
B_q = imhistmatch(ori_q,ref_q);

B_y_hist = imhist(B_y);
B_i_hist = imhist(B_i);
B_q_hist = imhist(B_q);

% Difference 

Y_diffm = mean2(abs(B_y_hist - ori_y_hist));
I_diffm = mean2(abs(B_i_hist - ori_i_hist));
Q_diffm = mean2(abs(B_q_hist - ori_q_hist));

Y_diffv = (std2(abs(B_y_hist - ori_y_hist)))^2;
I_diffv = (std2(abs(B_i_hist - ori_i_hist)))^2;
Q_diffv = (std2(abs(B_q_hist - ori_q_hist)))^2;

Y_diff = abs(B_y_hist - ori_y_hist);
I_diff = abs(B_i_hist - ori_i_hist);
Q_diff = abs(B_q_hist - ori_q_hist);

Y_diffs = skewness(Y_diff(:));
I_diffs = skewness(I_diff(:));
Q_diffs = skewness(Q_diff(:));

Y_diffk = kurtosis(Y_diff(:));
I_diffk = kurtosis(I_diff(:));
Q_diffk = kurtosis(Q_diff(:));

targetvect = [Y_diffm; I_diffm; Q_diffm; Y_diffv; I_diffv; Q_diffv; Y_diffs; I_diffs; Q_diffs; Y_diffk; I_diffk; Q_diffk ];
