function Haralick_FE(image_folders, p, path_output_folder)
%Function to calculate the Haralick features from the samples
%INPUT:
%       image_folder =  Folder of the sub-images
%       p = parameters used to create a model for the normalization
%       path_output_folder = the path where to save the new features
%
%
%There is not output because the features are directly saved on the folder

%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.


%Add folder paths
for i=1:length(image_folders)
    t = image_folders{i};
    addpath(genpath([char(t(1)),'/../']))
end

%Loop to extract the features from the samples
Tot_Features=[];
for j=1:length(image_folders)
    t = image_folders{j};
    
    for k=1:length(t)
        g = t{k};
        U = subfolders(g); %sub-image names
        
        %CHANGE IN CASE
        %%%%%%%%%%%%%%
        %This part is used to create the name of the new file considering
        %our original file names
        if isnumeric(strfind(g,'low')) == 1
            filename = strcat(path_output_folder,'/',g(128:end),'.mat');
        elseif  isnumeric(strfind(g,'high')) == 1
            filename = strcat(path_output_folder,'/',g(130:end),'.mat');
        end
        %%%%%%%%%%%%%%
        
        for i=1:length(U)
            imagel_processed(i,1) = U(i);
            
            %Reading of the image
            disp(['image countdown: ',num2str(length(U)-i)])
            I=imread(char(U(i)));

            %Color Normalitation function
            [ Inorm, H, E] = coloradjust( I, p);  %Normalized image shows more contrast and also homogeneity than the original one 
            I=Inorm;

            %Feature extraction
            %Matlab gracomatrix fuction and matworks function GLCM_Features4 are used in order to extract Haralich features.
            %In particular the GLCM_Features4 fuction allow to find 23 statistical features(Haralick, Soh and Clausi), but
            %only 13 Haralick feature are selected: Contrast, Correlation , Energy, Entropy, Homogeneity, Variance, Sum Average,
            %Sum Variance, Sum Entropy, Difference Entropy, Information measure of correlation1 and Information measure of
            %correlation2.

            %Graytone conversion
             Igray=rgb2gray(I);
             
            %CHANGE IN CASE
            %Delete pixels to have a perfect square for the size of the cell
            Igray=Igray(2:1249,2:1249);
            L_Cell=3;
            BlockSize=size(Igray,1)/L_Cell; %[416 416] in this way is divided in 9 part our image!
            %%%%%%%%%%%%%%%
            
            %Creation of Function Handle to use in blockproc. This function extract 13
            %Haralick features (using GLCM_Features4) from a gray level co-occurence matrix of
            %the image created by graycomatrix. In particular in this fuction it is
            %important to set up as parameters:
            %offset: angular direction for calculate the features in 0, 45 , 90 and 135 degree.
            %Symetric: consider ordering of values
            comatrix = @(d) reshape([  ...
               struct2array( ...
                   GLCM_Features4(...
                     graycomatrix(d.data,'Offset',[0 1; -1 1; -1 0; -1 -1],'Symmetric', true),0)) ...
              ],1,1,[]);

            %Blockproc allows to process block of image
            Features = blockproc(Igray,[BlockSize BlockSize],comatrix); %"Features" is a matrix with 52 layer which one with 0 45
            %90 135 degree value of the 13 Haralick features
            
            squeeze(Features(1,1,:)); %it returns vector for the upper left corner pixel
            Tot_Features=cat(1,Tot_Features,Features);

        end     
        %Save data
        save(filename, 'Tot_Features')
        
        Tot_Features=[];
        Features=[];
    end
end

end

