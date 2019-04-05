% QLDC_IM Classifies an image by blocks using QLDC 
% 
%   [C,P] = qldc_im(I,D,L,type,flag)
%
% INPUT 
%   I      An image for pixel classification
%   D      Training data matrix (without labels column) obtained from sampleClasses()
%   L      Training labels vector 
%   type   'quadratic','diagQuadratic','linear','diagLinear' (default: 'quadratic')
%   flag   0: no figure, 1: show posterior maps, 2: show posterior maps in color, 
%          3: show pseudo-colored segmentation 
%
% OUTPUT
%   C      Labeled image (crisp) 
%   P      Posterior maps (~ x ~ x k matrix) 
%
% DESCRIPTION
% Computes the pixel labels of a stack of images using a trained qldc
% classifier. The crisp labels follow the MAP rule. This function is written 
% to speed up classification of large images and to avoid memory overloading. 
% This is done by cutting an image into smaller square blocks, 
% performing pixel classification for each block, and then stitching up the
% blocks back into an image. The dimension of the square blocks are s x s 
% where s = 400 pixels (this may be changed within the function if necessary).

% Jimmy Azar, jimmy.azar@outlook.com
% qldc_im.m, 2016/04/04


function [C,P] = qldc_im(I,D,L,type,flag)

if nargin < 5 | isempty(flag)
	warning('No plot option specified\n');
    flag = 0;
end

if nargin < 4 | isempty(type)
	warning('type = ''quadratic''');
    type= 'quadratic';
end

if nargin < 3 | isempty(L)
	warning('No label vector specified!\n');
    return;
end

if nargin < 2 | isempty(D)
	warning('No training data specified!\n');
    return;
end

if nargin < 1 | isempty(I)
	warning('No image dataset specified!\n');
    return;
end

I = double(I);
s = 2500;%400; 
r = size(I,1);
c = size(I,2);
p = r*c;

if(p>s*s)
    for j = 1:ceil(r/s)
        display(['countdown: ',num2str(ceil(r/s)-j)]);
        for k = 1:ceil(c/s)
            x = I( (j-1)*s+1:min(j*s,r) , (k-1)*s+1:min(k*s,c), :);
            T = reshape(x,size(x,1)*size(x,2),size(x,3));
            [Cvec,E,Pmat] = qldc(T,D,L,type);
            y = reshape(Cvec,size(x,1),size(x,2));                       
            C( (j-1)*s+1:min(j*s,r), (k-1)*s+1:min(k*s,c) ) = y;
            for i=1:size(Pmat,2)
                z = reshape(Pmat(:,i),size(x,1),size(x,2));
                P( (j-1)*s+1:min(j*s,r), (k-1)*s+1:min(k*s,c), i ) = z;
            end
                
        end
    end
    
else
    T = reshape(I,r*c,size(I,3));
    [Cvec,E,Pmat] = qldc(T,D,L,type);
    C = reshape(Cvec,r,c);
    for i=1:size(Pmat,2)
        P(:,:,i) = reshape(Pmat(:,i),r,c);
    end
end


for i=1:size(Pmat,2)
    Pmaps{i} = squeeze(P(:,:,i));
end

I = uint8(I);

if (flag==1)
    linkplots([{I} Pmaps],0); % [{I} Pmaps] are 5 cell with the different tissue/cells in the image
end

if (flag==2)
    Id = double(I);
    for k=1:size(P,3)
        Q = [];
        for j=1:3
            Q(:,:,j) = P(:,:,k) .* Id(:,:,j);
        end
        Pcol{k} = uint8(Q);
    end
    linkplots([{I} Pcol],0); %Same as above but with color
end
    
if (flag==3)
    [C] = pscolor(Pmaps,rgb2gray(I),0.5);
    linkplots([{I} {C}],0);
end
    
end
