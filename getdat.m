%GETDAT Extracts labels vector from data matrix in standard format
% 
%  [D] = GETDAT(A)
% 
% INPUT
%   A      Dataset in standard format, including labels column
%
% OUTPUT
%   D      Data matrix returned i.e. excluding labels column
%
% DESCRIPTION
% Returns numeric data matrix without the labels column.

% Jimmy Azar, jimmy.azar@gmail.com
% getdat.m, 2016/06/10

function [D] = getdat(A)

if nargin < 1 | isempty(A)
    warning('No dataset specified!');
    return
end

D = A(:,1:end-1);

end