function table=readcsvcell(filename,jump,delim)
% Reads a CSV file to a struct. (TAB separated by default)
% TABLE=READCSVCELL(FILENAME,JUMP,DELIM)
%   FILENAME = file name
%   JUMP     = skips # of rows or to first occurence of string (int or string) (defaults to 0)
%   DELIM    = value delimiter (char(9) or ',', defaults to char(9)=tab)
%
%   TABLE    = struct, containing fields:
%       TABLE.COLUMNHEADS = cell vector of strings for header row
%       TABLE.DATA        = cell string array of data
%
% EXAMPLE:
%  table=readcsvcell('data.csv');
%  column=getcellcol(table,'Col 1')
% 
% Author: ville.rantanen@helsinki.fi   2010 03

if ~exist(filename,'file')
    error('Anduril:error',[filename ' is not found']);
    return
end

fid=fopen(filename,'rt');
%% get the column number
cols=0;
if ~exist('jump','var')
    jump=0;
end
if ~exist('delim','var')
        delim=char(9);
end

newjump=0;
if ~isnumeric(jump)
   while 1 
       tline=fgetl(fid);
       if ~ischar(tline), break,end
       newjump=newjump+1;
       if regexp(tline,['^' jump]), break,end
   end
   jump=newjump;
end
frewind(fid);
for r=1:jump
    tline=fgetl(fid);
end

while 1
    tline=fgetl(fid);
    if ~ischar(tline)
        cols=1;
        break
    end
    if ~strncmp(tline, '#',1)  % i.e. not a comment row
        k=strfind(tline, delim);
        cols=size(k,2)+1;
        try % if there are no delimiters at all
            if k(end)==numel(tline)
                cols=cols-1;
            end
        catch
            
        end
    end
    if cols>0
        break
    end
end
frewind(fid);
for r=1:jump
    tline=fgetl(fid);
end
data=textscan(fid,'%s','Delimiter',delim,'CommentStyle','END DATA');   % read all data
fclose(fid);

rows=size(data{:},1)/cols;
if  round(rows)~=rows
    cols=cols-1;
    rows=size(data{:},1)/cols; % the row ends with a delimiter
end

data=reshape(data{:}, [cols rows])';   % reshape to NxM
data=regexprep(data, '"', '');
table.columnheads=data(1,1:cols);
table.data=data(2:end,1:cols);

