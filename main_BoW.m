%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code created to generate the bag of words for the extracted features in 
%order to obtain one single vector that represent each sample.
%
%
%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Path of input data (the extracted features)
path_in='/ChemoResPredict/Output_folder/Features_output/';
%k cluster value
k=12;
%Where the BoW(output) will be saved
output_path=strcat('/ChemoResPredict/Output_folder/Bow_output/BoW_output_k=',string(k));
% %Eventually reduction of dataset
rid=[8,23,26,27,33,38,41]; %Case with PFI>1year and PFI<6months %rid=[]; %All samples are considered
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Name of samples
load Image_names
%Find all element in the folder
dirc=dir(path_in);
%Loop used to consider only the extracted features
n=1;
type={};
for i=3:length(dirc)
    type{1,n}=convertCharsToStrings(dirc(i).name);
    n=n+1;
end
%Loop used to consider all the LBP extracted
n=1;
LBP_type={};
if type{3}=='LBP'
    lbp_dirc=dir(strcat(path_in,type{3}));
    for i=3:length(lbp_dirc)
        LBP_type{1,n}=convertCharsToStrings(lbp_dirc(i).name);
        n=n+1;
    end
end

%Caculate the Bag of Words
BoW(name_samples,path_in,output_path,rid,k,type,LBP_type)