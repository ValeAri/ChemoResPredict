% VIZCELLS Visualize cell labels in image  
% 
%   [] = vizcells(I,mask,labels,u)
%
% INPUT 
%   I          Original RGB image
%   mask       Binary mask of objects (e.g. as returned from im2mask)
%   labels     Cell labels vector
%   u          Unique list of cell names (e.g. load trainset) 
%
% OUTPUT
%              Original image with cel label markers 
%
% DESCRIPTION
% Visualizes cell labels in an RGB image. Example: 
%
% load colordata_TCGA;
% [mask,C,P] = im2mask(I,a,[1],[50 Inf]);
% [F] = mask2feat(mask,P,I);
% D = F;
% load trainset_wo_circsample;
% D = D * V;
% [labels,~,~] = qldc(D,getdat(b),getlabels(b),'quadratic'); %classify all objects
% vizcells(I,mask,labels,u);

% Jimmy Azar, jimmy.azar@gmail.com
% vizcells.m, 2017/02/20

function [] = vizcells(I,mask,labels,u)

s  = regionprops(mask,'centroid');
centroids = cat(1, s.Centroid);

labels = num2label(labels,u);
figure; imshow(I,[]); hold on;
for i=1:size(labels,1)
    x = centroids(i,1); 
    y = centroids(i,2);
    if strcmp('Cancer',labels(i,1))
        plot(x,y,'bs','MarkerSize',10);
    elseif strcmp('Lymphocyte',labels(i,1))
        plot(x,y,'g*','MarkerSize',10);
    elseif strcmp('Macrophage',labels(i,1))
        plot(x,y,'m+','MarkerSize',10);
    elseif strcmp('Stromal',labels(i,1))
        plot(x,y,'ro','MarkerSize',10);
    elseif strcmp('VascularEndothel',labels(i,1))
        plot(x,y,'kx','MarkerSize',10);
    end    
end

h = zeros(5,1);
h(1) = plot(0,0,'bs', 'visible', 'off');
h(2) = plot(0,0,'g*', 'visible', 'off');
h(3) = plot(0,0,'m+', 'visible', 'off');
h(4) = plot(0,0,'ro', 'visible', 'off');
h(5) = plot(0,0,'kx', 'visible', 'off');
legend(h,'Cancer','Lymphocyte','Macrophage','Stromal','Vascular Endothel');

end

