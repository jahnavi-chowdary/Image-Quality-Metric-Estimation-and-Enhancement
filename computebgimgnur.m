function[bgImg, fundusMask, pointplot]= computebgimgnur(im, rmin, numrings, minpoints, flip)
%function[bgImg, fundusMask]= computebgimgnu(im)

[h, s, v]=rgb2hsv(im);

%fundusMask=v>0.1;
fundusMask=v>0.05;

size_orig=size(im); %size of image
size_orig(3)=[];

g=im(:, :, 2); %green image

%interpolating to 1024, 1024. dunno why
%g = imresize(g,[1024 1024]); %why
%im = imresize(im,[1024 1024]); %why
%mask = imresize(mask,[1024 1024]); 

sz=size(g);
centre=ceil(sz/2);
rmax=min(centre); %rmax.

threshold=1; %myeh

radii=zeros(1, numrings);

radii(1, 1)=0;
for k=2:numrings
    %disp(radii(1,k-1));
    radii(1, k)=radii(1,k-1)+1/((k+1));
end

radii=radii/radii(1, numrings)*(rmax-rmin)+rmin*ones(1,numrings);
%disp(r);
%disp(radii);

%radii = linspace(rmin,rmax,numrings); %measure of all radii

%numpoints = sqrt(minpoints).^(1:(numrings));
numpoints=ones(1, numrings);
for j=1:numrings
    numpoints(1,j)=minpoints*(j^3);
end

%numpoints = 10*ones(1, numrings);

if (flip==1)
    numpoints = int32(fliplr(numpoints)); %why
else
    numpoints = int32(numpoints); %why?
end

points = zeros(sum(numpoints),2); %wut
points = int32(points);

numpoints=double(numpoints); %argument for cosd, sind is double/single

temp =1 ;

for j =1 : numrings
    angseparation = 360/numpoints(j); %can we first fix number of points?
    angles = 0: angseparation : 360;  
    angles(end) = []; %360 is the same as 0
    radius = radii(j);
    
    points(temp : temp + length(angles)-1,1) = ceil(radius * cosd(angles') + centre(2)); %making list of points
    points(temp : temp + length(angles)-1,2) = ceil(radius * sind(angles') + centre(1));
    temp = temp + length(angles);
end


%list of points generated. YAY!

points=double(points);


[mean_val, var_val] = get_meanvar(g,points,125); %myeh some function
F = scatteredInterpolant(points(:,1),points(:,2),mean_val'); %myeh some function
% F = scatteredInterpolant(uint8(points(:,1)),uint8(points(:,2)),uint8(mean_val)');

[Xq,Yq] = meshgrid(1: sz(2),1:sz(1));
mean_interp = F(Xq,Yq);

F = scatteredInterpolant(points(:,1),points(:,2),var_val');
var_interp = F(Xq,Yq);


bgImg = abs((double(g) - mean_interp)./(var_interp+eps));
bgImg=bgImg<2;

pointplot=insertMarker(double(bgImg), points, 'x');
%bgImg=imresize(bgImg, size_orig);

%bgImg(~fundusMask)=0;
%bgImg(bgImg>threshold)=0;
%bgImg(bgImg~=0)=1;
%bgImg = logical(bgImg);


