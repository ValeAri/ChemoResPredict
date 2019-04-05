% sampleClasses Collect ROI Data from image & construct dataset
% 
%   [D] = sampleClasses(I,q)
%
% INPUT 
%   I      RGB image in [0 255] range or gray-scale image
%   q      Existing dataset in standard format (but not PRtools dataset) (default: q = [])
%
% OUTPUT
%   D      Dataset in standard format (but not a PRtools dataset)
%          3D scatter plot showing selected patterns in color-code label
%
% DESCRIPTION
% Interactively displays the image I, and waits for user to crop a region 
% of interest and choose a class number. In case 'I' is a color image, 
% the selected pixels are shown as patterns with same color in a 3D scatter plot. 
% The function may be exited using 'q' in the command window. The datset
% generated is stored in D. Use class order: nuceli, stroma, epithelium,
% lumen.

% Jimmy Azar, jimmy.azar@outlook.com
% sampleClasses.m, 2016/04/04


function [D] = sampleClasses(I,q)

if nargin < 2 | isempty(q)
	q = []; 
    warning('initial dataset empty');
end

if nargin < 1 | isempty(I)
	warning('No dataset specified!');
    return;
end

% generate markers
col = 'brmk';
sym = ['+*oxsdv^<>p']';
i   = [1:44];
p  = [col(i-floor((i-1)/4)*4)' sym(i-floor((i-1)/11)*11)];

close all;
c = 1;
if (isempty(q))
    b=[];
    L=[];
else 
    b = q(:,1:end-1);
    L = q(:,end);
end

i = '1';
while(~strcmp(i,'q'))
    k = str2num(i); %class number
    display(['Crop ROI: ',num2str(c),'   ','Class number: ',num2str(k)]);
    figure(1); 
    a = imcrop(I);
    a = reshape(a,size(a,1)*size(a,2),size(a,3)); %RGB or gray-scale
    lab = k*ones(size(a,1),1);
    close(figure(1));
    hold on; figure(99); 
    if (size(a,2)==3)
        scatter3(a(:,1),a(:,2),a(:,3),50,p(k,:));
    end
    xlim([0 255]); ylim([0 255]); zlim([0 255]);
    c = c + 1;
    b = [b; a];
    L = [L; lab];
    i = input('continue? Enter class number or q for quit: ','s');
end

D = [b L];
D = double(D);

% re-plot final scatterplot
close all;
if (size(b,2)==3)   
    for k=1:max(L)
        ind = find(L==k);
        scatter3(b(ind,1),b(ind,2),b(ind,3),50,p(k,:)); hold on; 
    end
    xlim([0 255]); ylim([0 255]); zlim([0 255]);
end

end
