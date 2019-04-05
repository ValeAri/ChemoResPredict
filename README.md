# Chemotherapeutic response prediction using histopathological image analysis

This repository contains Python and MATLAB source codes of the project: "Chemotherapeutic response prediction using histopathological image analysis". This pipeline allows to extract morphological and texture features from hematoxylin and eosin stained histopathological images, in order to use them to train classifiers. The aim of this study is to find the better features, single or combined, to predict the patient's response after the platinum-taxane chemotherapy.

NB. Because the best results were obtained for the combination of dictionary, the combination of the features before the BoW is not present in this pipeline.

# Input file
MRXS files
# Output file
To understand better how the output files are organized read the **README.md** file in Output_folder

# Deployment
The pipeline is composed by four main steps: Preprocessing, Feature Extraction, Feature encoding and Classification. Because the chose of classifiers depends on the available data, the code related to the classification is not present in the pipeline.

The workflow is shown in the following:

1_*'mrxa_preprocess'* Follow the instruction in **README**. There are two Python code: one allows to convert .mrxs to PNG image format and crop the original images in sub-images of 1250x1250 pixels. The other one allows to filter the sub-images to discard that one without information.
                                     
2_*'main_prepdata'* is used to organize the information about the samples, in particular their names, their position in the folder and their numeration. Remember to specify your directory in 'path, where the samples must be divided in the two categories: poor ("Low") response and good ("High") response. Two .mat files containing  the aforementioned information were produced: **Image_folders_bagid.mat** and **Image_names.mat**.

3_*'main_features_extraction'* allows to extract different type of features: Haralick features, rotation invariant uniform LBP (riu2), co-occurence of adjacent LBPs (CoALBP), rotation-invarian co-occurence of adjacent LBPs (RICLBP) and Complete LBPs (CLBP). The features, for all sample, are separately saved. It is possible to change the different variables to set for each features and it is necessary add the path of the folder chosen to save the new extracted features ('path_output_folder'). In this main code there are three important functions:
-*'coloradjust'*, this function is used to apply the color normalization to each sub-images and it is used before the extraction of all of the textural features.
-*'Haralick_FE'*, wih this code is possible to extract Halarick features from the images. It is necessary change the part related to the name of the files or the block dimensions of the images. It is also possible add other features changing manually 'GLCM_Features4' function. Haralick_FE fuction saves directly the extracted features in a folder.
-*'LBP_FE'* with this code is possible to extract 4 type of LBP features
(riu2, RICLBP,CoALBP and CLBP). As the previous function, it is necessary change the part related to the name of the files or the block dimensions of the images. LBP_FE fuction saves directly the extracted features in a folder.

4_*'main_build_trainset*' This main code is used to create the train set useful for the next step. It is necessary choose before a certain number of images as train set (ours are in **cell_labels_trnset_images**)!

5_*'main_run_builddata'* it is the code developed to extract morphological features. Also in this case it is necessary create a folder, in order to save the extracted features. The default name is **CellFeatures185** and it is necessary put the path on *'builddata2.m'*.

6_*'main_BoW'* allows to generate the bag of words for the extracted features in order to obtain one single vector that represent each sample.
it is possible to choose the k value for the clustering and which part of dataset you want use. In case, it is also possible modify the name of the output folders changing the name in the **Bow.m** function.

7_*'main_comb_Dict'* this code is created to combine the dictionary of different features after the application of Bow, it is possible selected which dictionaries combine. It is necessary change the path of the input and output folder and in case also the name of the output files.

### Prerequisites
Matlab version R2017a
Python 2.7
## Authors
**Ariotta Valeria**
