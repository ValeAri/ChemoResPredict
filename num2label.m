% NUM2LABEL Converts numerical labels to string labels 
%
%   [Ls] = num2labels(Ln,u)
%
% INPUT 
%   Ln      Numerical labels 
%   u       Cell string of unique names
%
% OUTPUT
%   Ls      Cell string labels
%
% DESCRIPTION
% Converts numerical label Ln to string label Ln using a unique set of
% string names u.

% Jimmy Azar, jimmy.azar@gmail.com
% num2label.m, 2016/07/12


function [Ls] = num2label(Ln,u)

if nargin < 2 | isempty(u)
	warning('No label names specified!');
    return;
end

if nargin < 1 | isempty(Ln)
	warning('No labels specified!');
    return;
end

K = length(u);
Ls = [{zeros(length(Ln),1)}];
for i=1:K
    f = (Ln==i);
    Ls(f) = u(i);
end

Ls = Ls';
end
