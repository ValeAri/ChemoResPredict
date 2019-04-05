function [ dataset ] = reduction( data, rid )
%This function returns a reduced dataset
%INPUT:
%       data = original dataset
%       rid  = parameter to set if you don't want use all the dataset. It is a vector with the number of data to exclude.
%OUTPUT:
%       dataset = return the cells which contains the name of the remained samples.


%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.

dim=1;
if isempty(rid)==logical(0) %it is not empity
    dataset=[];
    
    for i=1:length(data)
        if ismember(i,rid)==0 %Only the number of rid different from i!
            dataset{dim}=data{i}; %dataset construction
            dim=dim+1;
        end
    end
else
    dataset=data;
    display('No reduction is selected, the dataset remained the original one')
end

end

