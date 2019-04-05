% PSCOLOR Generate Pseudo-colored Image from a Stack of Posterior Maps
% 
%   [C] = pscolor(P,I,W)
%
% INPUT 
%   P       Posterior maps in [0,1] as cell structure {} 
%   I       Grayscale image  
%   W       Weight given to original image in [0,1] (optional; default = 0.5)  
%
% OUTPUT
%   C       Pseudo-colored image
%
% DESCRIPTION
% Generates a pseudo-colored image by multiplying each posterior map with a 
% preset 3-channel single-color uniform image and summing up. The sum is 
% superimposed with the original grayscale image I which is weighted by W.

% Jimmy Azar, jimmy.azar@gmail.com
% pscolor.m, 2013/06/11


function [C] = pscolor(P,I,W)

if nargin < 3 | isempty(W)
	warning('Using default weight');
    W = 0.5;
end

if nargin < 2 | isempty(I)
	warning('No image specified!');
    return;
end

if nargin < 1 | isempty(P)
	warning('No posterior maps specified!');
    return;
end

if size(I,3)~=1
	warning('Input image is not grayscale');
    return;
end

K = length(P);

% pseudo-colors
red = [1 0 0];
green = [0 1 0];
blue = [0 0 1];
violet = [1 0 1];
yellow = [1 1 0];
orange = [1.0000 0.6508 0];
colors = [red;green;blue;violet;yellow;orange];

clear PC;
[r,c] = size(I);
for i=1:K
    pc = colors(i,:);
    for j=1:3
        q(:,:,j) = ones(r,c)*pc(j);
        q(:,:,j) = q(:,:,j).*P{i};
    end
    PC{i} = q;
end

C = 1/255*repmat(double(I),[1 1 3]); %zeros(r,c,3);
C = W*C;

for i=1:K
    C = C + PC{i};
end

end

