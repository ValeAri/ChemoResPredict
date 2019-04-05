% FITELLIPSE Draws ellipses fitted over objects of a mask image
% 
%   [J,mask2,I2] = fitellipse(mask,I,flag)
%
% INPUT 
%   mask   Input mask (binary) image
%   I      Original RGB image, or image to impose with ellipses
%   flag   Plot flag (default: 1)
%
% OUTPUT
%   J      A binary image showing ellipse contours 
%   mask2  A binary mask image of ellipses 
%   I2     A color elliptic contour image superimposed onto original image I
%   []     Plots ellipses superimposed over the image I using plot() routine
%
% DESCRIPTION
% Draws ellipses fitted over objects of a mask image. The function uses
% regionprops() to find the parameters of the fitted ellipses. Note that
% mask2 is obtained by filling holes in J and then using watershedmask();

% Jimmy Azar, jimmy.azar@gmail.com
% fitellipse.m, 2016/07/08

function [J,mask2,I2] = fitellipse(mask,I,flag)

if nargin < 3 | isempty(flag)
	flag = 1;
end

if nargin < 2 | isempty(I)
	warning('Original image not specified!');
    return
end

if nargin < 1 | isempty(mask)
	warning('Input mask not specified!');
    return
end


s = regionprops(mask,{...
    'Centroid',...
    'MajorAxisLength',...
    'MinorAxisLength',...
    'Orientation'});

t = linspace(0,2*pi,1000);

if flag ==1
    figure(); 
    imshow(I,[]); hold on;
end

J = zeros(size(mask)); 
[R C] = size(mask); 
for k = 1:length(s)
    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;
    Xc = s(k).Centroid(1);
    Yc = s(k).Centroid(2);
    phi = deg2rad(-s(k).Orientation);
    x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
    y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
    
    if flag==1
        plot(x,y,'g','Linewidth',1);    
    end
    
    row = int64(floor(y));
    col = int64(floor(x));
    row(row<1)=1; row(row>R)=R;
    col(col<1)=1; col(col>C)=C;
    indices = sub2ind(size(mask), row, col);
    J(indices) = 1;
end

J = imdilate(J,strel('disk',1));
Ccol = zeros(size(mask,1),size(mask,2),3);
Ccol(:,:,2) = J;
mask2 = imfill(J,'holes');
mask2 = watershedmask(mask2);
I2 = 1.0.*double(I)/255 + Ccol;
%linkplots([{I2} {maskplus(mask,I)}],0)
end