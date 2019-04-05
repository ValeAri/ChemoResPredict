%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code developped to extract morphological features.
%
%
%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

tic
load Image_folders_bagid;%file obtained from main_prepdata 

load colordata_sharp; %this file is obtained using the function sampleClasses.m once with the images to analyze
load trainset_wo_circsample;%file obtained from main_build_trainset code
dismA =[];
A = [];
imlA = [];
imlA_processed = [];
%This fuction is used to extract morphological features
builddata2(image_folders,bagid,a,b,u,V,A,imlA,dismA,imlA_processed);
save PTOdata_Hercules B imlB baglV dismB imlB_processed;
toc

