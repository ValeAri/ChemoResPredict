# Chemotherapeutic response prediction using histopathological image analysis
This repository contains all the files obtained for the project: "Chemotherapeutic response prediction using histopathological image analysis".

## List of File
1)*'Features_output'* contains all the features extracted, both textural and morphological. Inside there are the folders:
*'CellFeatures185'* with the 185 morphological features extracted per 9 each sub-image,
*'Haralick'* with the Haralick features extracted per sub-image,
*'LBP'* with the LBP features extracted per sub-image, in particular there are the following folders:
  CLBP = Complete LBP
  CoALBP_plus and CoALBP_x = Co-occurence adjacent LBP
  RICLBP = Rotation invarian co-occurence among adjacent LBP
  Riu2 = Rotation invariant uniform LBP with different value of number of neighbours and radius between the center pixel and the neighborhood around
The name of each file correspond to the reference sample.

2)*'Bow_output'* contains the bag of words result of our samples. Inside each of these folders, there are the files obtained with different values of k (12,15,20) and there is also the folder **Combined**, which contains the bag of words of the combination of the dictionaries ("After_Bow"). The folders "2" and "3" represent the result of combination of 2 (Haralick+LBP) and 3 (Haralick+LBP+Morphological) features, each also contains the folders with different values of k.
The name of each file correspond to the reference features or combination of them.

### Prerequisites
Matlab version R2017a

## Authors
**Ariotta Valeria**
