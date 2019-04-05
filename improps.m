% IMPROPS Extract image region properties/features 
% 
%   [D] = improps(BW)
%
% INPUT 
%   BW      Binary image 
% 
% OUTPUT
%   D       Data matrix (columns = features), unlabeled   
%
% DESCRIPTION
% Extracts object shape properties from a binary image. Each object is a row in
% D; the number of columns are the number of features extracted. The shape
% properties are returned in the following order: 
%
% 'Area','Solidity','Eccentricity','EquivDiameter','Extent','MajorAxisLength','MinorAxisLength','Perimeter'
%
% Note: Solidity = Area/ConvexArea;  Eccentricity = c/a;  Extent = Area/AreaOfBoundingBox.  

% Jimmy Azar, jimmy.azar@gmail.com
% improps.m, 2016/06/28


function [D] = improps(bw)

if nargin < 1 | isempty(bw)
    warning('No image specified!');
    return
end

L = bwlabel(bw);
s = regionprops(L,'Area','Solidity','Eccentricity','EquivDiameter','Extent','MajorAxisLength','MinorAxisLength','Perimeter');
D = [cat(1,s.Area) cat(1,s.Solidity) cat(1,s.Eccentricity) cat(1,s.EquivDiameter) cat(1,s.Extent) cat(1,s.MajorAxisLength) cat(1,s.MinorAxisLength) cat(1,s.Perimeter)];

end



