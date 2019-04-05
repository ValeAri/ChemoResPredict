% FISHERMAP Finds Fisher mapping and transforms the data
% 
%   [B,V] = FISHERMAP(A,d)
%
% INPUT 
%   A      Data in standard format, including labels column
%   d      Desired number of features to retain (default: min(K,p)-1)
%
% OUTPUT
%   B      The transformed data in standard format, including labels column  
%   V      Matrix of eigenvectors as columns, sorted with descending eigenvalues
%
% DESCRIPTION
% Performs Fisher mapping, retaining d features and returns the transformed dataset B. 
% A matrix of eigenvectors V is also returned: new labeled data matrix Q can be mapped using
%
% q = getdat(Q)*V(:,1:d);
% Z = [q getlabels(Q)];

% Jimmy Azar, jimmy.azar@gmail.com
% fishermap.m, 2016/06/30

function [B,V] = fishermap(A,d)

p = size(getdat(A),2); 
K = max(getlabels(A));

if nargin < 2 | isempty(d)
	warning('Default number of features to retain: min(K,p)-1');
    d = min(p,K)-1; 
end

if nargin < 1 | isempty(A)
	warning('No dataset specified!)');
    return;
end

data = getdat(A);
class = getlabels(A); 
sw = Sw(data,class);
sb = Sb(data,class);
%tmp = sw\sb;
[V,D] = eig(sb,sw);

D(isnan(D)) = 0;
[s,I] = sort(diag(D),'descend');
V = V(:,I);
    
b = data*V(:,1:d);
B = [b class];
V = V(:,1:d);
end

% Within scatter
function out = Sw(data,class)
    out = zeros(size(data,2));
    classes = unique(class);
    for i = 1:length(classes)
        mask = (class==classes(i));%strcmp(class,classes{i});
        out = out + (sum(mask)/size(data,1))*cov(data(mask,:));
    end
end

% Between scatter
function out = Sb(data,class)
    out = zeros(size(data,2));
    classes = unique(class);
    for i = 1:length(classes)
        mask = (class==classes(i));%mappingstrcmp(class,classes{i});
        out = out + (sum(mask)/size(data,1))*...
        (mean(data(mask,:))-mean(data))'*...
        (mean(data(mask,:))-mean(data));
    end
end