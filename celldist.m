% CELLDIST Computes distance matrix between cell types
% 
%   [D2] = CELLDIST(D,K)
%
% INPUT 
%   D      Data as X, Y and labels column of object centroids.
%   K      Number of classes i.e. cell types 1,...,K
%
% OUTPUT
%   D2     Distance matrix over various cell types, including labels column   
%   D3     Distance between same type of cell, for have information about
%          density
% DESCRIPTION
% Computes the distance matrix between cell types as specified by
% the labels. Labels are numerical and can refer to 'cancer', 'lymphocyte',
% 'macrophage', 'stromal', 'vascular endothelial' as 1,...,5. Distances are
% computed between cell object centroids. Each row of D2 will contain in
% this case 5 elements corresponding to the closest distance to each cell
% type. 

%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.


function [D2,D3] = celldist(D,K)

if nargin < 2 | isempty(K)
	warning('Number of cell types not specified!');
    return; 
end

if nargin < 1 | isempty(D)
	warning('No dataset specified!');
    return; 
end

%Distance between different type of cells
L = D(:,end);
d = D(:,1:2); % X,Y columns
%K = max(L); 

D2 = zeros(size(D,1),K);
for j = 1:size(D,1)
    for i=1:K                                                                        
        data = d(L==i,:);
        if isempty(data)
            D2(j,i) = nan;
        else
            p = pdist2(data,d(j,:));
            if isempty(p(p>0)) 
                D2(j,i) = nan; 
            else
                D2(j,i) = min(p(p>0));   
            end
        end
    end
end

D2(:,end+1) = L;

%Distance between same type of cells

D3={};
Dist=[];
h=1;
for i=1:K
    pos=find(D(:,end)==i);
    data=D(pos,1:2);
    while length(data)>1
        d=data(h,:);
        data(h,:)=[];
        p = pdist2(data,d);
        Dist=[Dist;p];
    end
    D3{i}=Dist;
    Dist=[];
end

end