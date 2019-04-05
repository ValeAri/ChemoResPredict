function LBP_FE(image_folders, p, N, R,type,path_output_folder)
%Function to calculate different local binary patterns

%INPUT:
%       image_folder =  Folder of the images
%       p      = parameters used to create a model for the normalization
%       N      = Nosaka's Technique -> scale of LBP radius [default:1]  
%                Ojala's technique -> number of neighboors
%                Guo's technique -> number of neighborhood
%       R      = Nosaka's Technique -> interval of LBP pair [default:2]
%                Ojala's technique -> radius between the center pixel and the neighborhood around
%                Guo's technique -> radius between the center pixel and the neighborhood around
%       type   = Which kind of LBP technique you want use:
%                "riu2" (Ojala's Technique) 
%                "CoALBP" (Nosaka's Technique)
%                "RICLBP" (Nosaka's Technique)
%                "CLBP" (Guo's Technique)
%       path_output_folder = the path where save the extracted features
%
%There is not output because the features are directly saved on the folder


%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.

%add folder paths
for i=1:length(image_folders)
    t = image_folders{i};
    addpath(genpath([char(t(1)),'/../']))
end

%Different choise based on the type of LBP features you want extract
switch (type)
    case 'riu2'       
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
                %%%%%%%%%%%%%%%

                for i=1:length(U)
                    imagel_processed(i,1) = U(i);

                    %Reading of the sub-image
                    disp(['image countdown: ',num2str(length(U)-i)])
                    I=imread(char(U(i)));

                    %Color Normalitation function
                    [ Inorm, H, E] = coloradjust( I, p); %Normalized image shows more contrast and also homogeneity than the original one
                    I=Inorm;

                    %Graytone conversion
                     Igray=rgb2gray(I); 
                    
                     %CHANGE IN CASE
                     %Delete pixels to have a perfect square for the size of the cell
                     Igray=Igray(2:1249,2:1249);
                     L_Cell=3;
                     BlockSize=size(Igray,1)/L_Cell;
                     %%%%%%%%%%%%%%%
                     %LBP feature vector is returned as a 1-by-N vector of length N representing the number of features.
                     %The overall LBP feature length, N, depends on the number of cells and the number of bins, B:
                     %N = numCells x B
                     Features=extractLBPFeatures(Igray,'NumNeighbors',N,'Radius',R,'Upright',false,'CellSize',[BlockSize BlockSize]); 
                     Tot_Features(i,:)= Features;

                end
                %Save data
                save(filename, 'Tot_Features')

                Tot_Features=[];
                Features=[];
            end
        end
        
    case 'RICLBP' 
        Tot_Features=[];
        tic
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

                    %Reading of the sub-image
                    disp(['image countdown: ',num2str(length(U)-i)])
                    I=imread(char(U(i)));

                    %Color Normalitation function
                    [ Inorm, H, E] = coloradjust( I, p); %Normalized image shows more contrast and also homogeneity than the original one
                    I=Inorm;

                    %Graytone conversion
                     Igray=rgb2gray(I);
                     %LBP feature vector is returned as a 1-by-N vector of length N representing the number of features.
                     %The overall LBP feature length, N, depends on the number of cells and the number of bins, B:
                     %N = numCells x B
                     %RIC-LBP
                      M = getMap(4);
                      foo = @(img) [cvtRICLBP(img,N,R,M)];

                      Features = foo(Igray);
                      Tot_Features(i,:) = Features / norm(Features);

                end 
                %Save data
                save(filename, 'Tot_Features')
                Tot_Features=[];

            end
        end

    case 'CoALBP'     
        Tot_Features_plus=[];
        Tot_Features_x=[];
        tic
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
                    filename_plus = strcat(path_output_folder,'/CoALBP_plus/',g(128:end),'.mat');
                    filename_x = strcat(path_output_folder,'/CoALBP_x/',g(128:end),'.mat');
                elseif  isnumeric(strfind(g,'high')) == 1
                    filename_plus = strcat(path_output_folder,'/CoALBP_plus/',g(130:end),'.mat');
                    filename_x = strcat(path_output_folder,'/CoALBP_x/',g(130:end),'.mat');
                end
                %%%%%%%%%%%%%%%

                for i=1:length(U)
                    imagel_processed(i,1) = U(i);

                    %Reading of the image
                    disp(['image countdown: ',num2str(length(U)-i)])
                    I=imread(char(U(i)));

                    %Color Normalitation function
                    [ Inorm, H, E] = coloradjust( I, p);  %Normalized image shows more contrast and also homogeneity than the original one
                    I=Inorm;

                    %Graytone conversion
                     Igray=rgb2gray(I);
                     %LBP feature vector is returned as a 1-by-N vector of length N representing the number of features.
                     %The overall LBP feature length, N, depends on the number of cells and the number of bins, B:
                     %N = numCells x B
                     foo_plus = @(img)[cvtCoALBP(img,N,R,1)];
                     foo_x= @(img)[cvtCoALBP(img,N,R,2)];

                     Features_plus=foo_plus(Igray);
                     Tot_Features_plus(i,:) = Features_plus/ norm(Features_plus);
                     Features_x=foo_x(Igray);
                     Tot_Features_x(i,:)= Features_x/ norm(Features_x);

                end
                %Save data
                save(filename_plus, 'Tot_Features_plus')
                save(filename_x,'Tot_Features_x')

                Tot_Features_plus=[];
                Features_plus=[];
                Tot_Features_x=[];
                Features_x=[];
            end
        end
        
    case 'CLBP'
        % genearte CLBP features
        patternMapping = getmapping(N,'ri');

        for j=1:length(image_folders)
            t = image_folders{j};

            for k=1:length(t)
                g = t{k};
                U = subfolders(g); %image names

                %CHANGE IN CASE
                %%%%%%%%%%%%%%
                %This part is used to create the name of the new file considering
                %our original file names
                if isnumeric(strfind(g,'low')) == 1
                    filename = strcat(path_output_folder,'/',g(128:end),'.mat');
                elseif  isnumeric(strfind(g,'high')) == 1
                    filename = strcat(path_output_folder,'/',g(130:end),'.mat');
                end
                %%%%%%%%%%%%%%%

                for i=1:length(U)
                    imagel_processed(i,1) = U(i);
                    %Reading of the image
                    disp(['image countdown: ',num2str(length(U)-i)])
                    I=imread(char(U(i)));

                    %Color Normalitation function
                    [ Inorm, H, E] = coloradjust( I, p);  %Normalized image shows more contrast and also homogeneity than the original one
                    I=Inorm;

                    %Graytone conversion
                     Igray=rgb2gray(I); 

                    Igray = im2double(Igray);
                   
                    [CLBP_S,CLBP_M,CLBP_C] = clbp(Igray,R,N,patternMapping,'x');

                    % Generate histogram of CLBP_S
                    CLBP_SH(i,:) = hist(CLBP_S(:),0:patternMapping.num-1);

                    % Generate histogram of CLBP_M
                    CLBP_MH(i,:) = hist(CLBP_M(:),0:patternMapping.num-1);    

                    % Generate histogram of CLBP_M/C
                    CLBP_MC = [CLBP_M(:),CLBP_C(:)];
                    Hist3D = hist3(CLBP_MC,[patternMapping.num,2]);
                    CLBP_MCH(i,:) = reshape(Hist3D,1,numel(Hist3D));

                    % Generate histogram of CLBP_S_M/C
                    CLBP_S_MCH(i,:) = [CLBP_SH(i,:),CLBP_MCH(i,:)];

                    % Generate histogram of CLBP_S/M/C
                    CLBP_MCSum = CLBP_M;
                    idx = find(CLBP_C);
                    CLBP_MCSum(idx) = CLBP_MCSum(idx)+patternMapping.num;
                    CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
                    Hist3D = hist3(CLBP_SMC,[patternMapping.num,patternMapping.num*2]);
                    CLBP_SMCH(i,:) = reshape(Hist3D,1,numel(Hist3D));

                end
                save(filename, 'CLBP_SH','CLBP_S_MCH','CLBP_SMCH','CLBP_MCH','CLBP_SM')
                CLBP_SH=[];
                CLBP_MH=[];
                CLBP_MC=[];
                CLBP_MCH=[];
                CLBP_S_MCH=[];
                CLBP_SM=[];
                CLBP_SMH=[];
                CLBP_SMC=[];
                CLBP_SMCH=[];
            end
        end
end
end