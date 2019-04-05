%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code used to combine different dictionaries after the BoW technique.
%
%
%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%K value
k=12;
%Input path
pp=strcat('/ChemoResPredict/Output_folder/Bow_output/BoW_output_k=',string(k));
%Output path
pp_out=strcat('/ChemoResPredict/Output_folder/Bow_output/Combined/After_BoW/');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[file,path] = uigetfile(pp,'Select the dictionary to combine','MultiSelect','on');save_name='';
if iscell(file)==logical(1)
    
    %The file name are sorted in the chosen order
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if string(file{1})=='CellFeatures185_BoW.mat'
        %Concatenation
        if string(file{3})=='Haralick_BoW.mat'
            first=file{1};
            second=file{2};
            file{1}=file{3};
            file{2}=second;
            file{3}=first;
        else
            first=file{1};
            third=file{3};
            file{1}=file{2};
            file{2}=third;
            file{3}=first;     
        end
    end
    if string(file{2})=='Haralick_BoW.mat'
        first=file{1};
        file{1}=file{2};
        file{2}=first;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Creation of the output name
    filename=string(zeros(length(file),1));
    for i=1:length(file)
        filename(i)=sprintf('%s%s',path,file{i});
        %CHANGE IN CASE
        save_name=strcat(save_name,file{i}(1:end-8),'-');
    end
    %CHANGE IN CASE
    save_name=save_name(1:end-1);
    
    %Load data
    dataset=[];
    for i=1:length(file)
        dataset=[dataset, cell2mat(struct2cell(load(filename(i))))];
    end
else
    filename=sprintf('%s%s',path,file);
    dataset=cell2mat(struct2cell(load(filename)));
    save_name=file(1:end-8);
end
dim=string(size(file,2));
F=dataset;

%Save dictionary combination
output_path=strcat(pp_out,dim,'/BoW_output_k=',string(k));
%CHANGE IN CASE the name of the output file
filename=strcat(output_path,save_name,'_BoW.mat');
save(filename,'F');