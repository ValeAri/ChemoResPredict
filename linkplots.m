% LINKPLOTS Link Images as Subplots in a Figure
% 
%   [] = linkplots(I,FLAG)
%
% INPUT 
%   I       Image stack as cell structure {} 
%   FLAG    Use only subplot(2,~,1) in the first row if FLAG = 1 (default) 
%
% OUTPUT
%           A figure showing the images
%
% DESCRIPTION
% Displays a set of images as subplots in a figure and links them together
% so that zooming into one affects all others. The maximum-size layout is 
% fixed to 2 x 3 subplots so that number of images is limited to 6 for proper visibility.

% Jimmy Azar, jimmy.azar@outlook.com
% linkplots.m, 2013/06/04


function [] = linkplots(I,FLAG)

if nargin < 2 | isempty(FLAG)
	FLAG = 1;
end

if nargin < 1 | isempty(I)
	warning('No image dataset specified!');
    return;
end

if length(I) > 6 | (length(I)>4 & FLAG==1)
	warning('Function does not support over 6 images (or 4 if FLAG==1) for visibility');
    return;
end

if length(I) < 3 
    r = 1; c = 2;
else
    r = 2; c = 3;
end

figure('Position',get(0,'ScreenSize')); 
im = [];
im(length(im)+1) = subplot(r,c,1);
imshow(I{1},[]);
   
if (FLAG==1 & r==2)
    q=2; % to start on second row of subplots 
else
    q=0;
end

k = length(I);
for i = 2:k
        im(length(im)+1) = subplot(r,c,q+i); 
        imshow(I{i},[]);
end
linkaxes(im,'xy');


end

