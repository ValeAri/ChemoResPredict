function BoW(data_name,path,output_path,rid,k,type,LBP_type)
%Function used to calculate bag of words about samples composed by different
%elements (images in this case). In this function is
%possible apply the BoW for each feature.
%
%INPUT:
%       data_name     All the names of data of different samples
%       path          Path of extracted features
%       output_path   Path where the BoW will be saved
%       rid           Parameter to set if you don't want use all the dataset. It is a vector with the number of data to exclude or [] if you want use all the data.
%       k             Number of clusters
%       type          Which kind of features you want use. It is a string.
%                       The options are:
%                       'Haralick'
%                       'LBP'
%                       'CellFeatures185'
%       LBP_type = which kind of LBP features you want extracted
%There is not output because the BoW is directly saved on the folder.

%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.


%Choose of which data use for the BoW
dataset = reduction( data_name, rid );

%Choose of type of feature to extract
%Haralick
for j=1:length(type)
    feat=type{j};
    if ~isempty(find(feat=="Haralick"))==1
        cdata_H=[];
        for i=1:length(dataset)
            features_path=strcat(path,feat,'/',dataset{i});
            load(features_path);
            Features_H{i}=reshape(Tot_Features,size(Tot_Features,1)/size(Tot_Features,2),((size(Tot_Features,1)*size(Tot_Features,2)*size(Tot_Features,3))/(size(Tot_Features,1)/size(Tot_Features,2))));
            cdata_H=[cdata_H;Features_H{i}];
        end

        %Bag of word function
        [ F ] = BoW_function(cdata_H,Features_H, k);
        %Save data (CHANGE IN CASE)
        filename=strcat(output_path,'/Haralick_BoW.mat');
        save(filename,'F');
        disp('Haralick features have been extracted and saved')
    end

    %LBP
    if ~isempty(find(feat=="LBP"))==1
        for l=1:length(LBP_type)
            %CLBP is quite different from the other LBP features so it is
            %considered differently
            if string(LBP_type{l})=='CLBP'
                %Matrix with all date for a sample
                cdata_MCH=[];
                cdata_SH=[];
                cdata_SMCH=[];
                cdata_S_MCH=[];

                for i=1:length(dataset) strcat(dataset{i});
                    features_data=strcat(path,feat,'/', LBP_type{l},'/',dataset{i});
                    Features=load(features_data);

                    Features_MCH{i}=Features.CLBP_MCH;
                    Features_SH{i}=Features.CLBP_SH;
                    Features_SMCH{i}=Features.CLBP_SMCH;
                    Features_S_MCH{i}=Features.CLBP_S_MCH;

                    cdata_MCH=[cdata_MCH;Features.CLBP_MCH];
                    cdata_SH=[cdata_SH;Features.CLBP_SH];
                    cdata_SMCH=[cdata_SMCH;Features.CLBP_SMCH];
                    cdata_S_MCH=[cdata_S_MCH;Features.CLBP_S_MCH];
                end

                %Bag of word function
                [ F_MCH ] = BoW_function(cdata_MCH,Features_MCH, k);
                [ F_SH ] = BoW_function(cdata_SH,Features_SH, k);
                [ F_SMCH ] = BoW_function(cdata_SMCH,Features_SMCH, k);
                [ F_S_MCH ] = BoW_function(cdata_S_MCH,Features_S_MCH, k);

                %Save data (CHANGE IN CASE)
                filename=strcat(output_path,'/MCH_BoW.mat');
                save(filename,'F_MCH');
                filename=strcat(output_path,'/SH_BoW.mat');
                save(filename,'F_SH');
                filename=strcat(output_path,'/SMCH_BoW.mat');
                save(filename,'F_SMCH');
                filename=strcat(output_path,'/S_MCH_BoW.mat');
                save(filename,'F_S_MCH');

                disp('CLBP features have been extracted and saved')

            %For the other LBP features
            else
            %Matrix with all date for a sample
                cdata_LBP=[];
                for i=1:length(dataset)
                    features_path=strcat(path,feat,'/', LBP_type{l},'/',dataset{i});
                    Features_LBP{i}=struct2array(load(features_path));
                    cdata_LBP=[cdata_LBP; Features_LBP{i}];
                end

                %Bag of word function
                [ F ] = BoW_function(cdata_LBP,Features_LBP, k);
                %Save data (CHANGE IN CASE)
                filename=strcat(output_path,'/',LBP_type{l},'_BoW.mat');
                save(filename,'F');
                msg=strcat(LBP_type{l},' features have been extracted and saved');
                disp(msg)
            end
        end
    end

    %Morphological
    if ~isempty(find(feat=="CellFeatures185"))==1
        cdata_cell=[];
        %matrix with all date for a sample
        for i=1:length(dataset)
            features_path=strcat(path,feat,'/',dataset{i});
            Features_cell{i}=struct2array(load(features_path));
            cdata_cell=[cdata_cell; Features_cell{i}];
        end

        %Bag of word function
        [ F ] = BoW_function(cdata_cell,Features_cell, k);
        %Save data (CHANGE IN CASE)
        filename=strcat(output_path,'/CellFeatures185_BoW.mat');
        save(filename,'F');
        msg=strcat('Cell features have been extracted and saved');
        disp(msg)
    end

  end
end


