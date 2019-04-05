% IM2MASK Performs cell segmentation and returns a mask (binary) image 
% 
%   [mask,C,P] = IM2MASK(I,a,f,L)
%
% INPUT 
%   I       Original RGB image
%   a       Training dataset for quadratic classifier (e.g. load colordata)
%   f       Feature column numbers (e.g. [1 3 8]) to select as returned from improps(). Default: [1]. 
%   L       Feature limits matrix (min & max) (e.g. [50 150; 0.3 0.8]). Default: [20 Inf]. 
%
% OUTPUT
%   mask    Binary mask of (darkest) objects in image I (e.g. nuclei) 
%   C       Labeled image (crisp) 
%   P       Posterior maps (~ x ~ x k matrix) 
%
% DESCRIPTION
% Performs cell segmentation over typically H&E images using a quadratic
% classifier trained on labeled data in 'a'. The darkest grayscale
% probability map is selected and objects are filtered according to
% features specified in 'f' and limit values in 'L'.

% Jimmy Azar, jimmy.azar@gmail.com
% im2mask.m, 2016/07/12


function [mask,C,P] = im2mask(I,a,f,L)

if nargin < 4 | isempty(L)
	warning('Using default area limits: [20 Inf]');
    L = [20 Inf];
end

if nargin < 3 | isempty(f)
	warning('Using default feature: Area');
    f= [1];
end

if nargin < 2 | isempty(a)
	warning('No training dataset specified!');
    return;
end

if nargin < 1 | isempty(I)
	warning('No image specified!');
    return;
end

%classify
[C,P] = qldc_im(I,getdat(a),getlabels(a),'quadratic',0);

%find nuclei prob. map
%for i=1:size(P,3)
%    Pc{i} = P(:,:,i);
%end
%Sc = psort(Pc,rgb2gray(I),'ascend');
%mask = Sc{1};
mask = P(:,:,1);

%binarize and filter
mask= im2bw(mask,graythresh(mask));
if sum(~mask(:))==0  %mask all white
    mask = ~mask;
end
[mask] = watershedmask(mask); %watershed algorithm
mask =  filtermask(mask,f,L);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Draw an ellipse around each cell
%[J,mask,I2] = fitellipse(mask,I);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mask2 = maskplus(mask,I);
I = rgb2gray(mask2);
J = stdfilt(I,ones(3));
J = uint8(J);
J = (J>5); %elimination of some useless pixels
J = bwmorph(J,'thin',Inf); 
mask(J==1) = 0;
%Repetition of the watershed process to obtain better contour
[mask] = watershedmask(mask);%watershed algorithm
mask =  filtermask(mask,f,L);

end

