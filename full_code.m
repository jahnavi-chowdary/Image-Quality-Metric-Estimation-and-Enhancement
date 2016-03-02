% %% DMED

clc;
clear all;
close all;

normalimgPath = dir('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\Good\*.jpg');
for i = 1:length(normalimgPath)
    %Good Images
    file_name = normalimgPath(i).name;
    full_file_name = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\Good',file_name);
    im = imread(full_file_name);
    mask = create_mask(im,10);

    %Bad Images
    full_file_name2 = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\masks',file_name);
    im_noise = non_uniform_illumination(im);
    imwrite(mask,full_file_name2)
    
end

normalimgPath = dir('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\train\*.jpg');
% length(normalimgPath)
for i = 1:length(normalimgPath)
    file_name = normalimgPath(i).name;
%     [token, remain] = strtok(file_name,'.');
%     token = str2double(token);
    full_file_name = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\train',file_name);
    full_file_name2 = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\train\masks1',file_name);
    im = imread(full_file_name);
%     im = im2double(im);
    
    mask = imread(full_file_name2);
%     mask = im2double(mask);
    
    area = bwarea(mask);
    diameter = 2 * sqrt(area/pi);
    im = imresize(im,530/diameter,'bicubic');
    mask = imresize(mask,530/diameter,'bicubic');
    j = 1;
    [feats loc] = filterderivative_withLoc_save(im, mask); %Performing filterbank to obtain features
    number_of_samples = size(loc,1);
    sampled_data = zscore(feats');
    sampled_data = sampled_data';
    data{i} = sampled_data;
    locs{i} = loc;
    sizes(i) = size(sampled_data,1);
   % Creating a set of feature vectors for the training set
    complete_sampled_data(j:j+number_of_samples-1,:) = sampled_data;
    j = j + number_of_samples;
end

[IDX, C] = kmeans(complete_sampled_data,5,'MaxIter',500); 
xlswrite('C_value1.xlsx',C);

data1 = [];
tic
for z = 1 : length(sizes)
  for j = 1 : sizes(z)
        min_dist = 999999;
        for k = 1:5
            dist = norm(data{z}(j,1:25) - C(k,:));
            if dist < min_dist
                min_dist = dist;
                label = k;
            end
        end
        labels{j} = label;
  end   
    cnt = 0;
    rcnt = 0;
    gcnt = 0;
    bcnt = 0;
    wcnt = 0;
    test_img = [];
%    Assigning color to each class
    for i = 1:size(locs{z},1)
        if labels{i} == 1
            test_img(locs{z}(i,1),locs{z}(i,2),:) = 0;
            cnt = cnt + 1;
        elseif labels{i} == 2
            test_img(locs{z}(i,1),locs{z}(i,2),1) = 0;
            test_img(locs{z}(i,1),locs{z}(i,2),2) = 0;
            test_img(locs{z}(i,1),locs{z}(i,2),3) = 255;
            bcnt = bcnt + 1;
        elseif labels{i} == 3
            test_img(locs{z}(i,1),locs{z}(i,2),1) = 0;
            test_img(locs{z}(i,1),locs{z}(i,2),2) = 255;
            test_img(locs{z}(i,1),locs{z}(i,2),3) = 0;
            gcnt = gcnt + 1;
        elseif labels{i} == 4
            test_img(locs{z}(i,1),locs{z}(i,2),1) = 255;
            test_img(locs{z}(i,1),locs{z}(i,2),2) = 0;
            test_img(locs{z}(i,1),locs{z}(i,2),3) = 0;
            rcnt = rcnt + 1;
        elseif labels{i} == 5
            test_img(locs{z}(i,1),locs{z}(i,2),1) = 255;
            test_img(locs{z}(i,1),locs{z}(i,2),2) = 255;
            test_img(locs{z}(i,1),locs{z}(i,2),3) = 255;
            wcnt = wcnt + 1;
        end
    end
    file_name = normalimgPath(z).name;
    full_file_name = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\train\clusters1',file_name);
%     figure; imshow(test_img);
    imwrite(test_img, full_file_name)
    isc_hist = [cnt, rcnt, gcnt, bcnt, wcnt]./size(locs{z},1);
    
    [rcounts,~] = imhist(test_img(:,:,1),5);
    rcounts = rcounts./numel(test_img(:,:,1));
    
    [gcounts,~] = imhist(test_img(:,:,2),5);
    gcounts = gcounts./numel(test_img(:,:,2));
    
    [bcounts,~] = imhist(test_img(:,:,3),5);
    bcounts = bcounts./numel(test_img(:,:,3));
    
    feature_vector = [isc_hist, rcounts' , gcounts' , bcounts'];
    feature_vector = zscore(feature_vector');
    feature_vector = feature_vector';
    data1 = [data1; feature_vector];
end
toc
xlswrite('training1.xlsx',data1);

%
% Test

C = csvread('C_value1.csv');
testimgPath = dir('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\test\*.jpg');
% testimgPath = [dir('J:\data\10-fold\EXP1\test\*.png');dir('J:\data\10-fold\EXP1\test\*.jpg')];

data_test = [];

for num = 1:length(testimgPath)
 
    file_name = testimgPath(num).name;
%     [token, remain] = strtok(file_name,'.');
%     token = str2double(token);
    full_file_name = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\test',file_name);
    full_file_name2 = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\test\masks1',file_name);
    im = imread(full_file_name);

    test_im = im;
    mask = imread(full_file_name2);
 
    area = bwarea(mask);
    diameter = 2 * sqrt(area/pi);
    test_im = imresize(test_im,530/diameter,'bicubic');
    mask = imresize(mask,530/diameter,'bicubic');
    j = 1;
    [feats loc] = filterderivative_withLoc_save(test_im, mask);
    feats = zscore(feats');
    feats = feats';
    %Identifying each pixel to a class and assigning corresponding label
    for j = 1:size(feats,1)
        min_dist = 999999;
        for k = 1:5
            dist = norm(feats(j,1:25) - C(k,:));
            if dist < min_dist
                min_dist = dist;
                label = k;
            end
        end
        feats(j,26) = label;
    end
    cnt = 0;
    rcnt = 0;
    gcnt = 0;
    bcnt = 0;
    wcnt = 0;
    %Assigning color to each class
    for i = 1:size(loc,1)
        
        if feats(i,26) == 1
            test_im(loc(i,1),loc(i,2),:) = 0;
            cnt = cnt + 1;
        elseif feats(i,26) == 2
            test_im(loc(i,1),loc(i,2),1) = 0;
            test_im(loc(i,1),loc(i,2),2) = 0;
            test_im(loc(i,1),loc(i,2),3) = 255;
            bcnt = bcnt + 1;
        elseif feats(i,26) == 3
            test_im(loc(i,1),loc(i,2),1) = 0;
            test_im(loc(i,1),loc(i,2),2) = 255;
            test_im(loc(i,1),loc(i,2),3) = 0;
            gcnt = gcnt + 1;
        elseif feats(i,26) == 4
            test_im(loc(i,1),loc(i,2),1) = 255;
            test_im(loc(i,1),loc(i,2),2) = 0;
            test_im(loc(i,1),loc(i,2),3) = 0;
            rcnt = rcnt + 1;
        elseif feats(i,26) == 5
            test_im(loc(i,1),loc(i,2),1) = 255;
            test_im(loc(i,1),loc(i,2),2) = 255;
            test_im(loc(i,1),loc(i,2),3) = 255;
            wcnt = wcnt + 1;
        end
    end
    full_file_name3 = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\test\clusters1',file_name);
    imwrite(test_im, full_file_name3)

    isc_hist = [cnt, rcnt, gcnt, bcnt, wcnt]./size(loc,1);
    [rcounts,~] = imhist(test_im(:,:,1),5);
    rcounts = rcounts./numel(test_im(:,:,1));
    [gcounts,~] = imhist(test_im(:,:,2),5);
    gcounts = gcounts./numel(test_im(:,:,2));
    [bcounts,~] = imhist(test_im(:,:,3),5);
    bcounts = bcounts./numel(test_im(:,:,3));
    feature_vector = [isc_hist, rcounts' , gcounts' , bcounts'];
    feature_vector = zscore(feature_vector');
    feature_vector = feature_vector';
    data_test = [data_test; feature_vector];
    %find feature vector for this test image
%     Group = svmclassify(SVMStruct,feature_vector);
%     data = {file_name,Group};
%     test_result = [test_result;data];
end
xlswrite('testing1.xlsx',data_test);

trn_lbl = [ones(58,1); zeros(14,1); 1; 0; 1; 1; 0; 0; 1; 1; 0; 1; zeros(46,1); 1; 1; 0; 0];

tst_lbl = [zeros(58,1); ones(14,1); 0; 1; 0; 0; 1; 1; 0; 0; 1; 0; ones(46,1); 0; 0; 1; 1];
% [predict_lbl, accuracy, dec_val] = svmpredict(tst_lbl, data_test, model);


% addpath('./libsvm-3.20/matlab');
% 
train_ftr = csvread('./training1.csv');
test_ftr = csvread('./testing1.csv');
% 
% train_lbl = csvread('./train_lbl_1.csv');
% test_lbl = csvread('./test_lbl_1.csv');
% 
% train_ftr = PCA(train_ftr_1,2);
% [train_lbl, permIndex] = sortrows(train_lbl_1);
% train_ftr = train_ftr(permIndex,:);
% 
% % figure;
% % plot(train_ftr(1:9,1),train_ftr(1:9,2),'r*');
% % hold on;
% % plot(train_ftr(10:18,1),train_ftr(10:18,2),'b*');
% % hold off;
% 
% test_ftr = PCA(test_ftr_1,2);
% [test_lbl, permIndex] = sortrows(test_lbl_1);
% test_ftr = test_ftr(permIndex,:);
% 
% % figure;
% % plot(test_ftr(1:9,1),test_ftr(1:9,2),'r*');
% % hold on;
% % plot(test_ftr(10:18,1),test_ftr(10:18,2),'b*');
% % hold off;
% 
h_train = train_ftr;
% trn_lbl = train_lbl';
% 
h_test = test_ftr;
% tst_lbl = test_lbl';
% 
h1 = size(train_ftr,1);
randorder1 = randperm(h1);
h_train = h_train(randorder1, :);
trn_lbl = trn_lbl(randorder1, :);
% 
h2 = size(test_ftr,1);
randorder2 = randperm(h2);
h_test = h_test(randorder2, :);
tst_lbl = tst_lbl(randorder2, :);
% 
% % Using Libsvm svmtrain
% % 
% % TRAIN
% bestcv = 0;
% for log2c = -2:0.1:2,
%   for log2g = -2:0.1:2,
%       l1 = sum(trn_lbl == 0); l2 = sum(trn_lbl == 1);
%       w1 = 100*(l2/(l1+l2));  w2 = 100*(l1/(l1+l2));
% 
%       cmd = ['-q -s 2 -v 10 -c ', num2str(10^log2c) ' -w-1 '  num2str(w1) ' -w1 ' num2str(w2)];
%     cmd = ['-t 2 -v 5 -c ', num2str(10^log2c), ' -g ', num2str(10^log2g)];
%     cv = svmtrain(trn_lbl, h_train, cmd);
%         if cv >= bestcv
%       bestcv = cv; bestc = 10^log2c; bestg = 10^log2g;
%         end
%  
%   end
% end
% 
% clc
% fprintf('(best c=%g, g=%g, rate=%g)\n', bestc, bestg, bestcv);
% cmd = ['-t 2 -c ', num2str(bestc), ' -g ', num2str(bestg)];
% model = svmtrain(trn_lbl,h_train, cmd);
%  
% % TEST
% [predict_lbl_train, accuracy1, dec_val1] = svmpredict(trn_lbl, h_train, model);
% [predict_lbl_tst, accuracy2, dec_val2] = svmpredict(tst_lbl, h_test, model);
% 
% % Using Matlab Svmtrain
%  
% training_full = [trn_lbl,h_train];
% 
% After grid.py


gamma = 0.0078125
% gamma = 0.05
c = 20
sigma = 1/(sqrt(2*gamma));
SVMStruct = svmtrain(h_train,trn_lbl,'kernel_function','rbf','boxconstraint',c,'rbf_sigma',sigma);

predict_lbl_train = svmclassify(SVMStruct,h_train);
predict_lbl_tst = svmclassify(SVMStruct,h_test);

accuracy_train = ((132 -(nnz(abs(predict_lbl_train - trn_lbl))))/132 ) * 100
accuracy_test = ((132 - (nnz(abs(predict_lbl_tst - tst_lbl))))/132 ) * 100

lab = [trn_lbl,predict_lbl_train,tst_lbl,predict_lbl_tst];

difference_train =  predict_lbl_train - trn_lbl;
TP_train = 66 - length(find(difference_train == -1));
FP_train = 66 - TP_train;
TN_train = 66 - length(find(difference_train == 1));
FN_train = 66 - TN_train;

Sensitivity_train = (TP_train /(TP_train + FN_train))*100;
Specificity_train = (TN_train /(TN_train + FP_train))*100;

difference_tst =  predict_lbl_tst - tst_lbl;
TP_tst = 66 - length(find(difference_tst == -1)) ;
FP_tst = 66 - TP_tst;
TN_tst = 66 - length(find(difference_tst == 1)); 
FN_tst = 66 - TN_tst;

Sensitivity_tst = (TP_tst /(TP_tst + FN_tst))*100;
Specificity_tst = (TN_tst /(TN_tst + FP_tst))*100;

[Sensitivity_train, Specificity_train, Sensitivity_tst, Specificity_tst]
[TP_train, FP_train, TN_train, FN_train]
[TP_tst, FP_tst, TN_tst, FN_tst]