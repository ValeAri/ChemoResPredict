%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code created to extract different type of textural features: Haralick
%features, rotation invariant uniform LBP (riu2), co-occurence of adjacent
%LBPs (CoALBP), rotation-invarian co-occurence of adjacent LBPs (RICLBP)
%and Complete LBPs (CLBP).
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load folders path
load('Image_folders_bagid')

%Load parameters for color normalization
load('polyfit_parameter'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Declaration of editable variables 
MyParams = struct(...
    'Haralick',struct(...
        'path_output_folder','ChemoResPredict/Output_folder/Features_output/Haralick'),... %Output folder path
    'riu2',struct(...
        'path_output_folder','ChemoResPredict/Output_folder/Features_output/LBP/Riu2(16,3)',...
        'N',16,... %number of neighboors
        'R',20,... %radius between the center pixel and the neighborhood around
        'type','riu2'),...
     'CoALBP',struct(...
        'path_output_folder','ChemoResPredict/Output_folder/Features_output/LBP/',... %Output folder path
        'N',8,... %scale of LBP radius
        'R',30,... %interval of LBP pair
        'type','CoALBP'),...
    'RICLBP',struct(...
        'path_output_folder','ChemoResPredict/Output_folder/Features_output/LBP/RICLBP',... %Output folder path
        'N',8,... %scale of LBP radius
        'R',30,... %interval of LBP pair
        'type','RICLBP'),....
    'CLBP',struct(...
        'path_output_folder','ChemoResPredict/Output_folder/Features_output/LBP/CLBP',... %Output folder path
        'N',8,...%number of neighborhood
        'R',5,... %radius between the center pixel and the neighborhood around
        'type','CLBP')....
        );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Features extraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Haralick features extraction
tic
Haralick_FE(image_folders, p, MyParams.Haralick.path_output_folder)
disp('Haralick features have been extracted')
toc

%LBP features extraction
%Ojala's features extraction
tic
LBP_FE(image_folders, p, MyParams.riu2.N, MyParams.riu2.R, MyParams.riu2.type,MyParams.riu2.path_output_folder)
disp('riu2 features have been extracted')
toc

%Nosaka's features extraction
tic
LBP_FE(image_folders, p, MyParams.CoALBP.N, MyParams.CoALBP.R,MyParams.CoALBP.type,MyParams.CoALBP.path_output_folder)
disp('CoALBP features have been extracted')
toc

tic
LBP_FE(image_folders, p, MyParams.RICLBP.N, MyParams.RICLBP.R, MyParams.RICLBP.type, MyParams.RICLBP.path_output_folder)
disp('RICLBP features have been extracted')
toc

%Guo's features extraction
tic
LBP_FE(image_folders, p, MyParams.CLBP.N, MyParams.CLBP.R,MyParams.CLBP.type,MyParams.CLBP.path_output_folder)
toc
disp('CLBP features have been extracted')