function [ F ] = BoW_function(data,Features, k)
%Function used to calculate bag of words about samples composed by different
%elements (images in this case)
%INPUT:
%       data        all the data of the difference sample, with in the row 
%                   the observation and in the column the features
%       features    cell structure that contains for each column the
%                   imgxfeatures cell
%       k           number of clusters
%OUTPUT:
%       F          BoW for the samples, it is a vector for each sample

%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.


%Search of kmeans (codebook)
[foo,centers]=kmeans(data,k,'MaxIter',500);

%Bow Encoding
for i=1:length(Features)
    [C,dist] = knnsearch(centers, Features{i},'Distance','euclidean','k',1);

     %search for the frequencies == Histogram
    [F(i,:),edges] = histcounts(C,1:(k+1));

    %Normalization
    F(i,:)=F(i,:)/sum(F(i,:));
    
end

end