% FILTERMASK Selects objects in mask image having certain feature values 
% 
%   [mask2] = FILTERMASK(mask,f,L)
%
% INPUT 
%   mask     Mask (binary) image
%   f        Feature column numbers (e.g. [1 3 8]) to select as returned from improps()  
%   L        Feature limits matrix (min & max) (e.g. [50 150; 0.3 0.8])
%
% OUTPUT
%   mask2    New mask with only the selected objects that have passed the filters 
%
% DESCRIPTION
% Poses restrictions on objects in a mask image. Shape properties are specified in the following order: 
% 
%  'Area','Solidity','Eccentricity','EquivDiameter','Extent','MajorAxisLength','MinorAxisLength','Perimeter'
%
% Jimmy Azar, jimmy.azar@gmail.com
% fishermap.m, 2016/06/30

function [mask2] = filtermask(mask,f,L)

mask = imfill(mask,'holes');
l = bwlabel(mask);

D = improps(mask);

if isempty(D)
    mask2 = mask; 
else
    F = D(:,f);

    for i=1:length(f)
        ind{i}= find((F(:,i) > L(i,1)) & (F(:,i) < L(i,2)));
    end

    idx = ind{1};
    for i=2:length(f)
        idx = intersect(idx,ind{i});
    end

    mask2 = ismember(l,idx);
end

end

