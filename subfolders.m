% SUBFOLDERS Extracts subfolder names of a specified folder
% 
%   [W] = subfolders(P)
%
% INPUT 
%   P       Directory path of main folder 
%
% OUTPUT
%   W       Subfolder names as cells {}
%
% DESCRIPTION
% Extracts subfolder names of a specified folder. 

% Jimmy Azar, jimmy.azar@gmail.com
% subfolders.m, 2016/06/15

function [W] = subfolders(p)

if nargin < 1 | isempty(p)
	warning('No directory path specified!');
    return;
end

W = [];
Z = dir(p);
cnt = 0; 
for i=3:length(Z)
    cnt = cnt + 1;
    W{cnt} = Z(i).name;
end

end



