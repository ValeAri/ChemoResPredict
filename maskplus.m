% MASKPLUS Superimposes a mask image with the original RGB image   
% 
%   [maskp] = MASKPLUS(mask,I)
%
% INPUT 
%   mask    Mask (binary) image
%   I       RGB image in range [0 255], uint8
%
% OUTPUT
%   maskp   Mask superimposed with original image I
%
% DESCRIPTION
% Superimposes mask with original RGB image.

% Jimmy Azar, jimmy.azar@gmail.com
% maskplus.m, 2016/07/06


function [maskp] = maskplus(mask,I)

if nargin < 2 | isempty(I)
    warning('No RGB image specified!');
    return;
end

if nargin < 1 | isempty(mask)
    warning('No mask specified!');
    return;
end

maskp = double(I).*repmat(mask,1,1,3);
maskp = uint8(maskp); 

end

