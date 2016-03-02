testimgPath1 = dir('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\masks\*.jpg');
for num = 1:length(testimgPath1)
    file_name = testimgPath1(num).name;
    full_file_name = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\masks',file_name);
    full_file_name1 = fullfile('C:\Users\Jahnavi Chowdary\Desktop\DMED\misc\ISC\misc\Manual_NUI\masks_padded',file_name);
    test_im = imread(full_file_name);
    test_out = padarray(test_im,[200,200],'both');
    imwrite(test_out,full_file_name1)
    
end