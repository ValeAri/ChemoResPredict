% TABLE2IM Extracts unique image names from H&E table   
% 
%   [U,M] = TABLE2IM(tablename)
%
% INPUT 
%   tablename  Filename string of table (e.g. 'HE_table.txt')
%
% OUTPUT
%   U          Unique list of image names in the table, as cell strings  
%   M          Number of unique images  
%
% DESCRIPTION
% Extracts a list of unique image names from an H&E table.

% Jimmy Azar, jimmy.azar@gmail.com
% table2im.m, 2016/07/26


function [u,m] = table2im(tablename)

if nargin < 1 | isempty(tablename)
	warning('No table specified!');
    return;
end

table = readcsvcell(tablename);
d = table.data;
u = unique(d(:,2));
m = length(u);

end