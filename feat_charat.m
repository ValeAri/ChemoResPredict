function [ F ] = feat_charat( M, D )
%This function is created to calculate minimum, maximum, mean, standard
%deviation and variance for each features. Finally, it returns the organized
%data.
%INPUT:
%      M        Matrix with features
%      D        Cell with information about distance between same type of cells
%OUTPUT:    
%      F        Matrix with the output data

%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.


if nargin < 2 | isempty(M)
	warning('Matrix of features is not specified!');
    M= zeros(1,8);
end

if nargin < 1 | isempty(D)
	warning('No distance cell is specified!');
    
end

features=[];
for i=1:size(M,2)
    features=[features, min(M(:,i)),max(M(:,i)),mean(M(:,i)),var(M(:,i)),std(M(:,i))];
end
 
F =[features,min(D),max(D),mean(D),var(D),std(D)];
                    
end

