%GETLABELS Extracts labels vector from data matrix in standard format
% 
%  [L] = GETLABELS(A)
% 
% INPUT
%   A      Dataset in standard format, including labels column
%
% OUTPUT
%   L      Labels column vector returned
%
% DESCRIPTION
% Extracts labels column vector from dataset A.

% Jimmy Azar, jimmy.azar@gmail.com
% getlabels.m, 2016/06/10

function [L] = getlabels(A)

if nargin < 1 | isempty(A)
    warning('No dataset specified!');
    return
end

L = A(:,end);

end