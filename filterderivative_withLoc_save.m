function [feats loc]= filterderivative_withLoc(im, mask)
[m n dim]=size(im);
if dim>1
    im=double(im(:,:,2));
%     disp 'filterderivative: <Extracted Green Channel from the color image >  '
else
    im=double(im);
end

green = im;

if ~exist('scale')
    scl=[1 2 4 8 16]; %% Number of scale
else
    scl=scale;
end

loc = [];
mask = uint8(im2double(mask));
[loc(:,1), loc(:,2)]= find(mask);
feats=zeros(size(loc,1),25);

im = extension(im,mask);% Fundus extension

[tmp num]= size(scl);
epsilon=1e-2;

L= zeros(size(im,1), size(im,2), size(scl,2));
Lvv= zeros(size(im,1), size(im,2), size(scl,2));
Lvw= zeros(size(im,1), size(im,2), size(scl,2));
Lww= zeros(size(im,1), size(im,2), size(scl,2));
pos= 1;
z = 1;

   for k=1:num
    sigma=scl(k);
    halfsize=ceil(sigma*sqrt(-2*log(sqrt(2*pi)*sigma*epsilon)));
    sze=2*halfsize+1;
    gauss= fspecial('gaussian',sze,sigma);
    L(:,:,k)= imfilter(im,gauss);
   
    [Lx,Ly] = gradient(L(:,:,k));
    [Lxx,Lxy]= gradient(Lx);
    [Lyx,Lyy]= gradient(Ly);
     
    Lx = abs(Lx);
    Ly = abs(Ly);
    Lxx = abs(Lxx);
    Lxy = abs(Lxy);
    Lyx = abs(Lyx);
    Lyy = abs(Lyy);
              
    Lw(:,:,k)= sqrt(Lx.^2+Ly.^2);
    
    % Computing numerator of Lvv
    Lvv_num = (- 2 * Lx .* Lxy .* Ly) + (Lxx .* (Ly.*Ly)) + ((Lx.*Lx).* Lyy);
    % Computing numerator of Lvw 
    Lvw_num= (-1*(Lx.*Lx) .* Lxy) + ((Ly.*Ly) .* Lxy) + (Lx.*Ly .*(Lxx-Lyy));
    % Computing numerator of Lww 
    Lww_num= ((Lx.*Lx) .* Lxx) + (2* Lx.* Lxy.*Ly) + ((Ly.*Ly) .* Lyy);
    % Denominator for the computation of filters Lvv, Lvw and Lww 
    den = (Lx.*Lx + Ly.*Ly);
    
    for c=1:size(loc,1)
        i = loc(c,1); j = loc(c,2);
        feats(c,pos)=L(i,j,k);
        feats(c,pos+1)=Lw(i,j,k);
        % Computation for Lvv
        feats(c,pos+2) = Lvv_num(i,j)/den(i,j);
        % Computation for Lvw
        feats(c,pos+3) = Lvw_num(i,j)/den(i,j);
        % Computation for Lww
        feats(c,pos+4) = Lww_num(i,j)/den(i,j);
    end
    pos=pos+5;
end
