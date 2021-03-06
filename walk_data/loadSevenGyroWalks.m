function loadSevenGyroWalks()
    walks = {'gl4east1.csv' 'gl4west1.csv' 'gl6east1.csv' 'gl7east1.csv' 'gl7west1.csv'};

    for i=1:length(walks),
        data = loadGyroWalk(strcat('sevenGyroWalks/',walks{i}));
        
        % Trim away non-continuous gait data (i.e. standing or moving
        % unpredictably)
        if strcmp(walks{i}, 'gl4east1.csv')
            data = data(160:690,:);
        end
        if strcmp(walks{i}, 'gl4west1.csv')
            data = data(1:406,:);
        end
        
        L_cols = {'Pelvis_X', 'Pelvis_Y', 'Pelvis_Z', 'LFEP_X', 'LFEP_Y', 'LFEP_Z', 'LFEO_X', 'LFEO_Y', 'LFEO_Z', 'LTIO_X', 'LTIO_Y', 'LTIO_Z'};
        R_cols = {'Pelvis_X', 'Pelvis_Y', 'Pelvis_Z', 'RFEP_X', 'RFEP_Y', 'RFEP_Z', 'RFEO_X', 'RFEO_Y', 'RFEO_Z', 'RTIO_X', 'RTIO_Y', 'RTIO_Z'};
        assignin('base', 'gl_L_cols', L_cols)
        assignin('base', 'gl_R_cols', R_cols)
        assignin('base', strcat(walks{i}(1:end-4),'_R'), data(:,1:12))
        assignin('base', strcat(walks{i}(1:end-4),'_L'), data(:,[1:3 13:end]))
    end
end

function walk = loadGyroWalk(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   GL4EAST1 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   GL4EAST1 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   gl4east1 = importfile('gl4east1.csv', 9, 813);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2014/01/20 12:56:16

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 9;
    endRow = inf;
end

%% Format string for each line of text:
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: double (%f)
%   column23: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
walk = [dataArray{1:end-1}];
end