function [ Inorm, H, E] = coloradjust(I, p)
%Function to adjust the color of the RGB image using Macenko's stain
%normalization
%INPUT:
%       I     =  Image to normalize
%       p     =  parameters used to create a model for the normalization
%       k     =  number of clusters
%OUTPUT:
%       Inorm = Normalized Image
%       H     = Hematoxilyn normalized image
%       E     = Eosin normalized image

%Copyright (c) 2018, Valeria Ariotta
%Systems Biology of Drug Resistance in Cancer
%University of Helsinki
%Helsinki, Finland
% 
% See the License.txt file for copying permission.

if ~exist('I', 'var') || isempty(I)
    error('No image specified!');
    return
end
if ~exist('n', 'var') || isempty(n)
    n = 0;
end

%Cie*LAB conversion
cform = makecform('srgb2lab');
I_lab = applycform(I,cform);
I_lab = double(I_lab);
l = mat2gray(I_lab(:, :, 1)); % lightness

%figure()
% subplot(1,2,1),imshow(I),title('Image');
% subplot(1,2,2),imshow(l),title('lightness');

%Normalization
IOD_l=sum(sum(l)); %integreted optical density
y = polyval(p,IOD_l);
%Normalitation based on Machenko filter
[Inorm, H, E] = normalizeStaining(I,y,0.1);%beta is imposed always with value 0.1
     
% figure()
% subplot(1,2,1),imshow(I),title('Image');
% subplot(1,2,2),imshow(Inorm),title('Image normalized');

end

