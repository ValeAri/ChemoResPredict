% LABEL2NUM Converts string labels to numerical labels 
% 
%   [Ln] = label2num(Ls,s)
%
% INPUT 
%   Ls      Cell string labels 
%   s       Unique cell string of labels 
%
% OUTPUT
%   Ln      Numerical labels
%
% DESCRIPTION
% Converts string label Ls to numerical label Ln.

% Jimmy Azar, jimmy.azar@gmail.com
% label2num.m, 2016/07/12


function [Ln] = label2num(Ls,s)

if nargin < 1 | isempty(Ls)
	warning('No labels specified!');
    return;
end

u = unique(s);
K = length(u);

Ln = zeros(length(Ls),1);
for i=1:K
    f = strcmp(u(i),Ls);
    Ln(f) = i;
end

end
