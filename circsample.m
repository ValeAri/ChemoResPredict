% CIRCSAMPLE Sample using concentric rings around an object shape 
% 
%   [Y] = CIRCSAMPLE(M,P,R,W)
%
% INPUT 
%   M     Mask (binary) image of objects as foreground
%   P     Class posterior probability maps (images) as matrices (~ x ~ x k)
%   R     Number of rings or dilations (default: 10) 
%   W     Width of square structuring element (default: 3) 
%
% OUTPUT
%   Y     Statistical count of each class in each of the rings  (n x R*K)
%
% DESCRIPTION
% Constructs concentric rings around each object in the labeled image
% using dilation and subtraction. The fraction of a class is counted 
% in every ring. These are then concatenated with K parts where K is the 
% number of classes. 

% Jimmy Azar, jimmy.azar@gmail
% circsample.m, 2016/07/25


function [Y] = circsample(M,P,R,W)

if nargin < 4 | isempty(W)
	W = 3;
    warning('Width of square structuring element: 3 (default)');
end

if nargin < 3 | isempty(R)
	R = 10;
    warning('Number of rings is 10 (default)');
end

if nargin < 2 | isempty(P)
    warning('No posterior maps specified!');
    return;
end

if nargin < 1 | isempty(M)
    warning('No mask image specified!');
    return;
end

L = bwlabel(M);

for i=1:size(P,3)
    Q{i} = P(:,:,i);
end
P = Q;

% Derive concentric rings around each object
K = length(P);
df = K;   % deg of freedom
clear Y;
se = strel('square',W);

for i = 1:max(L(:))
    %display(['coundown:...',num2str(max(L(:))-i)])
    %clear d; 
    %clear y;
    d = [];
    d{1} = (L==i);
    y = [];
    for j = 1:R
        d{j+1} = imdilate(d{j},se);
        c = d{j+1}-d{j};
        %clear f;
        f = [];
        for h=1:df      %df = k-1
            t = c.*P{h};
            f(h) = sum(t(:))/sum(c(:));
        end
        y = [y f];   
    end
    y = reshape(y,df,R)';
    y = y(:)';           
    Y(i,:) = y;
end

end