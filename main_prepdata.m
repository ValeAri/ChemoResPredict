%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code created to organize the information about the samples, in particular
%their names, their position in the folder and their numeration.
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input path
path='/.../ChemoResPredict/Input_Folder'; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Path of samples
F_low = [path filesep 'low'];
F_high = [path filesep 'high']; 

%Distiction among samples "Low" and "High"
f_low= subfolders(F_low);
f_high= subfolders(F_high);

%Folder path of low sample
clear image_folderL;
for i=1:length(f_low)
    image_folderL{i} = [F_low filesep f_low{i}];    
end

%Folder path of high sample
clear image_folderH;
for i=1:length(f_high)
    image_folderH{i} = [F_high filesep f_high{i}];    
end

%Folder path of all the samples
image_folders = [{image_folderL} {image_folderH}];

%Generate bagid for "Low" samples
n = [];
cnt = 0;
bagid_low =[];
for i=1:length(f_low)
    G = [F_low filesep f_low{i}]; 
    g = subfolders(G);
    g = g{1};
    t = g(1:12);
    if sum(strcmp(n,{t}))==0
        cnt = cnt +1;
        bagid_low = [bagid_low; cnt]; 
    else
        ind= find(strcmp(n,{t}),1);
        v = bagid_low(ind);
        bagid_low = [bagid_low; v]; 
    end
    n = [n; t];
end

%Generate bagid for "High" samples
n = [];
cnt = 0;
bagid_high = [];
for i=1:length(f_high)
    G = [F_high filesep f_high{i}]; 
    g = subfolders(G);
    g = g{1};
    t = g(1:12);
    if sum(strcmp(n,{t}))==0
        cnt = cnt +1;
        bagid_high = [bagid_high; cnt]; 
    else
        ind= find(strcmp(n,{t}),1);
        v = bagid_high(ind);
        bagid_high = [bagid_high; v]; 
    end
    n = [n; t];
end

bagid_high = bagid_high + max(bagid_low);

%Create a vector with all bagid samples
bagid = [bagid_low; bagid_high];

%Storage the name of the differnt sample
name_samples=[];
for i=1:length(f_low)
    name_samples{i}=f_low{i};
end
for j=1:length(f_high)
    name_samples{i+j}=f_high{j};
end

%Save of the information
save Image_folders_bagid image_folders bagid;
save Image_names name_samples;

