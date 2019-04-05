%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code used to create the trainset for the segmentation steps.
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

addpath([pwd filesep 'cell_labels_trnset_images']);

%loop over images
load colordata; %this file is obtained using the function sampleClasses.m once with the "train images"
tablename = 'HE_table.txt'; %It is a table of nuclei with their labels and locations 
							%The table was obtained by allowing the pathologist to interactively click on sample cells in the images, (folder "cell_labels_trnset_images")
[u,m] = table2im(tablename);
table = readcsvcell(tablename);
d = table.data;
D = [];
%Built of the trainset
for i = 1:length(u)
   sprintf('counter:...%d', length(u)-i+1)
   imID = u(i);
   I = imread(char(u(i)));
   [mask,C,P] = im2mask(I,a,[1],[50 Inf]);
   [A,missed(i),duplicates(i)] = annotatemask(mask,imID,tablename,P);
   D = [D; A]; 
end

q = D(:,end);
ind = (strcmp(q,'Cancer') | strcmp(q,'Lymphocyte') | strcmp(q,'Stromal') | ...
       strcmp(q,'VascularEndothel'));
E = D(ind,:);

%Make numerical labeled data matrix
u = unique(E(:,end));
labels = label2num(E(:,end),u);
F = cell2mat(E(:,2:end-1));
F(:,end+1) = labels; 

%Fisher map
[b,V] = fishermap(F,[]);
save trainset_wo_circsample b V u;
