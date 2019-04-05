% SUMMARY_CELLDIST Averages over cell distance matrix 
% 
%   [D2] = SUMMARY_CELLDIST(D)
%
% INPUT 
%   D      Distance matrix as returned by celldist(): each row gives the 
%          closest distances of an object to each cell type. The last column holds the object label.
%
% OUTPUT
%   D2     Average distance matrix: for each cell type, the distances in D are averaged.
%
% DESCRIPTION
% Provides an average summary of the distance matrix returned by
% celldist(). D2 will contain one row for each cell type. The last column
% in D2 carries the cell type label. 

% Jimmy Azar, jimmy.azar@gmail.com
% summary_celldist.m, 2016/07/28

function [D2] = summary_celldist(D)

if nargin < 1 | isempty(D)
	warning('No distance matrix specified!');
    return; 
end

L = getlabels(D); 
K = size(getdat(D),2);%max(L); 

for i=1:K
    idx = (D(:,end)==i);
    if sum(idx)==0
        D2(i,:) = NaN(1,K);
    else
        %D2(i,:) = mean(D(idx,1:end-1),1,'omitnan');
        D2(i,:) = max(D(idx,1:end-1),[],1,'omitnan');
    end
end
D2 = [D2 [1:K]'];

end
