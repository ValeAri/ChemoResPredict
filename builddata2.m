function builddata2(image_folders,bagid,a,b,u,V,A,imlA,dismA,imlA_processed)
%This function allows to extract morphological features from images. In
%particular builddata2 is used to invoke the the function
%mainfunc_builddata2.m in which the sub-image is divided in 9 patches and for 
%each of them morphological features are extracted. 
%
%
% INPUT 
%   image_folders  Folders of sub-images as: image_folders = [{image_folderL} {image_folderH}];
%                  Each of the 2 subfolders are also cells of folders: image_folderL{1} = '...' 
%   bagid          Bag IDs as column vector with as many elements as there are folders (e.g. [1 1 1 2 3]).
%   a              RGB Color dataset (labeled), used for pixel classification
%   b              Labeled training set of annotated cell types used for cell classification
%   u              Label string names corresponding to numerical labels used in 'b'
%   V              Fisher map coefficients for mapping into Fisher space
%   A              Existing (instance-labeled) dataset (default: A=[])
%   imlA           Vector of image names as cells (as many rows as rows in A) (default: imlA=[]).
%   dismA          Distances matrix from each cell-type to every other type.     
%   imlA_processed Vector of image names of images previously processed (in folders)
%
%

%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.



if nargin < 10 | isempty(imlA_processed)
	warning('Previous image names not secified; default []');
    imlA_processed = [];  
end

if nargin < 9 | isempty(dismA)
	warning('No distance matrix specified; default []');
    dismA = [];  
end

if nargin < 8 | isempty(imlA)
	warning('No image names specified; default []');
    imlA = []; 
end

if nargin < 7 | isempty(A)
	warning('No existing TTP dataset specified; default []');
    A = []; 
end

if nargin < 6 | isempty(V)
	warning('No Fisher coefficients specified!');
    return; 
end

if nargin < 5 | isempty(u)
	warning('No cell-type label names specified!');
    return; 
end

if nargin < 4 | isempty(b)
	warning('No annotated cell type dataset specified!');
    return; 
end

if nargin < 3 | isempty(a)
	warning('No RGB color datset specified!');
    return; 
end

if nargin < 2 | isempty(bagid)
	warning('No bag IDs specified for each folder');
    return; 
end

if nargin < 1 | isempty(image_folders)
	warning('No image folders specified!');
    return; 
end


%add folder paths
for i=1:length(image_folders)
    t = image_folders{i};
    addpath(genpath([char(t(1)),'/../']))
    %for j=1:length(t)
    %    disp(['addpath countdown: ',num2str(length(t)-j)])
    %    addpath(char(t(j)));
    %end
end


delete(gcp);
myCluster=parcluster('local'); 
myCluster.NumWorkers=8; 
parpool(myCluster,7)

%Parameter initialization
imlB_processed = []; 
dismB = {[]};
nm=0;

%Load
load 'Image_names'

for j=1:length(image_folders) %Number of cells
    t = image_folders{j}; %Considering the different cells separately
    dst = [];
    
    for k=1:length(t) %Considering the j cell
        g = t{k}; %consdiering the k sample
        U = subfolders(g); %sub-image names; all the images for the k sample
        parfor i=1:length(U)
           imagel_processed(i,1) = U(i);
            if (sum(strcmp(U(i),imlA_processed))~=0) && (sum(strcmp(U(i),imlA))==0)
                disp([U(i), '... already found processed (skipping)'])
                cl(i,1) = -1;
                rlymph(i,1) = 0;
                rstroma(i,1) = 0;
                rvasc(i,1) = 0;
                rcancer(i,1) = 0;
                dism{i} = {[]};
                imagel{i} = {' '};
                bagl(i,1) = 0;
                continue;
            end
            if sum(strcmp(U(i),imlA))~=0
                imagel{i} = U(i);
                f = find(strcmp(imlA,U(i))==1); %should return only 1 location
                cl(i,1) = A(f,1);
                dism{i} = dismA{f};
                rcancer(i,1) = A(f,2);
                rlymph(i,1) = A(f,3);
                rstroma(i,1) = A(f,4);
                rvasc(i,1) = A(f,5);
                if j== 2
                   bagl(i,1) = bagid(k+length(image_folders{j-1})); 
                else
                    bagl(i,1) = bagid(k);
                end
                disp([U(i), '... already found processed (copying)'])
                continue;
            end
            disp(['image countdown: ',num2str(length(U)-i)])
            Img = imread(char(U(i)));
           
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Function used to extract the morphological features
            % It is implemented in order to use the parfor loop and speed
            % up the process
            
            tot_feats{i} = mainfunc_builddata2( Img,a, image_folders,V, b,u);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end       

        %Save the features for each sample (50 features from
        %patch)
        tot_feat = cat( 1, tot_feats{:} );
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %CHAGE HERE the name and/or the path of the folder
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        path_output_features='ChemoResPredict/Output_folder/Features_output/CellFeatures185';
        filename=strcat(path_output_features,'/',string(name_samples{nm}),'.mat');
        save(filename,'tot_feat')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        tot_feats={};
        tot_feat=[];
        path_output_features=[];

    end
end

