function [ tot_feat ] = mainfunc_builddata2( Img,a, image_folders,V, b,u)
%This code is used to extract 185 features for each patch of the image. The features are the
%following:
%Min, Max, Mean, Var, SD of:
%Area, Solidity,Eccentricity, EquivDiameter, Extent, MajorAxisLength,
%Minoraxislength,Perimeter and same type of cell distance.
% plus five other features:
%number of cancer cells, lymphocyte cells, stroma cells, vascend cells and
%Hausdorff distance between different kind of cells.
%This function is created to give the possibility to use the parfor loop in
%the previous function.
%
% INPUT:
%   Img            The selected image
%   a              RGB Color dataset (labeled), used for pixel classification
%   image_folders  Folders of images as: image_folders = [{image_folderL} {image_folderH}];
%                  Each of the 2 subfolders are also cells of folders: image_folderL{1} = '...' 
%   V              Fisher map coefficients for mapping into Fisher space
%   b              Labeled training set of annotated cell types used for cell classification
%   u              Label string names corresponding to numerical labels used in 'b'
% OUTPUT:
%   tot_feat      All extracted features per image

%Copyright (c) 2018, Valeria Ariotta
%Sys­tems Bio­logy of Drug Res­ist­ance in Can­cer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.

n=9; %number of patch
Img_rid=Img(2:1249,2:1249,:); %Used to have exactly 9 patch per image
L_Cell=3;
BlockSize=size(Img_rid,1)/L_Cell;
T=[];

for cc=0:L_Cell-1
    for rr=0:L_Cell-1
        %patch
        I=Img_rid((cc*BlockSize)+1:(cc+1)*BlockSize,(rr*BlockSize)+1:(rr+1)*BlockSize,:); %Portion of sub-image are considered
        if size(I,3)~=3
            cl(i,1) = 0;
            rlymph(i,1) = 0;
            rstroma(i,1) = 0;
            rvasc(i,1) = 0;
            rcancer(i,1) = 0;
            dism{i} = {[]};
            imagel{i} = {' '};
            bagl(i,1) = 0;
            continue
        end
        
        [mask,C,P] = im2mask(I,a,[1],[50 Inf]); %cell segmentation

        %Msk{j,k,i} = mask;
        %Pmap{j,k,i} = P;            
        if sum(mask(:))==0
            cl = 0;
            rlymph= 0;
            rstroma = 0;
            rvasc = 0;
            rcancer = 0;
            dism = {[]};          
        end

        [F] = mask2feat(mask,P,I);
        if isempty(F)==0 %blank mask are not considered
            D = F;
            ext_D=D(:,1:end-9); %Morph features matrix
            D = D * V;
            [L,~,~] = qldc(D,getdat(b),getlabels(b),'quadratic'); %classification of objects
            D = [D L];
            s  = regionprops(mask,'centroid');
            centroids = cat(1, s.Centroid); %calculation of centroids
            ext_Feat=[ext_D centroids L]; %Morfological features + classification cells

            %Features vector for each type of cells
            cancer_feat=zeros(length(find(ext_Feat(:,end)==1)),size(ext_Feat,2)-1);
            dim_c=1;
            lymp_feat=zeros(length(find(ext_Feat(:,end)==2)),size(ext_Feat,2)-1);
            dim_l=1;
            stroma_feat=zeros(length(find(ext_Feat(:,end)==3)),size(ext_Feat,2)-1);
            dim_s=1;
            vascEnd_feat=zeros(length(find(ext_Feat(:,end)==4)),size(ext_Feat,2)-1);
            dim_ve=1;
            for ll=1:size(ext_Feat,1)
                if ext_Feat(ll,end)==1
                    cancer_feat(dim_c,:)=ext_Feat(ll,1:size(ext_Feat,2)-1);
                    dim_c=dim_c+1;
                elseif ext_Feat(ll,end)==2
                    lymp_feat(dim_l,:)=ext_Feat(ll,1:size(ext_Feat,2)-1);
                    dim_l=dim_l+1;
                elseif ext_Feat(ll,end)==3
                    stroma_feat(dim_s,:)=ext_Feat(ll,1:size(ext_Feat,2)-1);
                    dim_s=dim_s+1;
                 elseif ext_Feat(ll,end)==4
                     vascEnd_feat(dim_ve,:)=ext_Feat(ll,1:size(ext_Feat,2)-1);
                     dim_ve=dim_ve+1;
                end
            end
            %Calculation of the two type of distance
            [dst,Dist_same_cells]=celldist(ext_Feat(:,9:11),length(u));

            for pp=1:size(Dist_same_cells,2)
                if isempty(Dist_same_cells{pp})
                    Dist_same_cells{pp}=NaN;
                end
            end

            %Features extraction:
            %area,solidity,eccentricity,equivDiameter, extent, majorAxisLength, minorAxisLength, perimeter,
            %Euclidean distance.
            cancer_feat2= feat_charat(cancer_feat(:,1:8), Dist_same_cells{1});
            lymp_feat2= feat_charat(lymp_feat(:,1:8), Dist_same_cells{2});
            stroma_feat2= feat_charat(stroma_feat(:,1:8), Dist_same_cells{3});
            vascEnd_feat2= feat_charat(vascEnd_feat(:,1:8), Dist_same_cells{4});
            
            %Last five features: percentage of cells and Hausdorff distance
            labels = getlabels(D);
            labels = num2label(labels,u);
            Ncancer = sum(strcmp(labels,'Cancer')) ;
            Nlymph =  sum(strcmp(labels,'Lymphocyte')) ;
            Nstroma = sum(strcmp(labels,'Stromal')) ;
            Nvasc =  sum(strcmp(labels,'VascularEndothel'));
            N = length(labels);
            rcancer = Ncancer/N; %Cancer
            rlymph = Nlymph/N;  %Lymphocyte
            rstroma = Nstroma/N; %Stromal
            rvasc = Nvasc/N; %Vasc.End
            dst_summary = summary_celldist(dst);
            cl = dst_summary(1,2);
            dism = dst;

            %organization of data
            T=[T; cancer_feat2 rcancer lymp_feat2 rlymph stroma_feat2 rstroma vascEnd_feat2 rvasc cl];

            cancer_feat2=[];
            lymp_feat2=[];
            stroma_feat2=[];
            vascEnd_feat2=[];
            ext_Feat=[];
        end
    end
end
tot_feat=T;
end

