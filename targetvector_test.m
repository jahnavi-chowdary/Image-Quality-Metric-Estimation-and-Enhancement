clc;
close all;

% imagefiles = dir(fullfile('C:', 'Users', 'Jahnavi Chowdary', 'Desktop', 'DMED', 'DMED', '*.jpg'));      
% nfiles = length(imagefiles);    % Number of files found
% for ii=1:nfiles
%    currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
%    images{ii} = currentimage;
% end
tic;
c = Dmed('../DMED');
id = c.getNumOfImgs;
q = [];
% Sort and take top 30 and bottom 30 without considering range
for i = 1 : id
    q(i) = c.getQuality(c.idMap(i));
end

[q_sort id_sort] = sort(q);
id_new = id_sort;
q_new = q_sort;

l = label(q_sort);

%Training Data
% q_new = [q_sort(1:30),q_sort(140:169)]';
% id_new = [id_sort(1:30),id_sort(140:169)]';
% l(1:30,1) = 0;
% l(31:60,1) = 1;

% q_new = [q_sort(1:50),q_sort(120:169)]';
% id_new = [id_sort(1:50),id_sort(120:169)]';
% l(1:50,1) = 0;
% l(51:100,1) = 1;

%Testing Data
% q_t_new = [q_sort(31:40),q_sort(130:139)]';
% id_t_new = [id_sort(31:40),id_sort(130:139)]';
% l_t(1:10,1) = 0;
% l_t(11:20,1) = 1;

% q_t_new = [q_sort(51:60),q_sort(110:119)]';
% id_t_new = [id_sort(51:60),id_sort(110:119)]';
% l_t(1:10,1) = 0;
% l_t(11:20,1) = 1;

% Training
for i = 1 : size(id_new,2)
    
%     im1 = imread('./Tests/Target2/test2/input.jpg');
    im1 = c.getImg(id_new(i));
    im1 = im2double(im1);

%     ref = imread('./Tests/Target2/test2/target.jpg');
%     ref = imread('C:\Users\Jahnavi Chowdary\Desktop\codes\Targets\target1.jpg');
    ref = c.getImg(id_new(length(id_new)));
    ref = im2double(ref);

    targetvect_rgb = rgb_features(im1,ref);
    targetvect_lab = lab_features(im1,ref);
    targetvect_hsv = hsv_features(im1,ref);
%     targetvect_xyz = xyz_features(im1,ref);
%     targetvect_yiq = yiq_features(im1,ref);
%     targetvect_ycbcr = ycbcr_features(im1,ref);

    [lum con] = lumandcon(im1);
    finalvect_train(i,:) = [targetvect_rgb; targetvect_lab; targetvect_hsv; lum; con]';
%     finalvect_train(i,:) = [targetvect_rgb; targetvect_lab; targetvect_hsv; targetvect_xyz; targetvect_yiq; targetvect_ycbcr; lum; con]';

end 

% Testing
% for i = 1 : size(id_t_new)
%     
% %     im1 = imread('./Tests/Target2/test2/input.jpg');
%     im1 = c.getImg(id_t_new(i));
%     im1 = im2double(im1);
% 
% %     ref = imread('./Tests/Target2/test2/target.jpg');
% %     ref = imread('C:\Users\Jahnavi Chowdary\Desktop\codes\Targets\target1.jpg');
%     ref = c.getImg(id_new(length(id_new)));
%     ref = im2double(ref);
% 
%     targetvect_rgb = rgb_features(im1,ref);
%     targetvect_lab = lab_features(im1,ref);
%     targetvect_hsv = hsv_features(im1,ref);
%     targetvect_xyz = xyz_features(im1,ref);
%     targetvect_yiq = yiq_features(im1,ref);
%     targetvect_ycbcr = ycbcr_features(im1,ref);
% 
%     [lum con] = lumandcon(im1);
% 
%     finalvect_test(i,:) = [targetvect_rgb; targetvect_lab; targetvect_hsv; targetvect_xyz; targetvect_yiq; targetvect_ycbcr; lum; con]';
% 
% end 
toc