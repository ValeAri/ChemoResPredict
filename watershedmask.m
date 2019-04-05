% WATERSHEDMASK Apply watershed over binary mask to split touching objects 
% 
%   [mask2] = watershedmask(mask)
%
% INPUT 
%   mask     Input mask (binary) image, (fg=1, bg=0)
%
% OUTPUT
%   mask2    Output mask (binary) image  
%
% DESCRIPTION
% Applies watershed segmentation over a binary mask to seprate touching
% objects. 

% Jimmy Azar, jimmy.azar@gmail.com
% watershedmask.m, 2016/07/08


function [mask2] = watershedmask(mask)

if nargin < 1 | isempty(mask)
    warning('Input mask not specified!');
    return
end

D = -bwdist(~mask);
im = imextendedmin(D,2);  %internal markers
D2 = imimposemin(D,im);
L = watershed(D2);

mask2 = mask; 
mask2(L==0) = 0 ; 

end
