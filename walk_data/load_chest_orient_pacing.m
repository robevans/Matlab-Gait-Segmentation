function load_chest_orient_pacing(simulateRespeck, doPCA)

if nargin < 1
    simulateRespeck = true;
end

if nargin < 2
    doPCA = false;
end

orient_walks = {'pacing0.csv' 'pacing1.csv' 'pacing2.csv' 'pacing3.csv'};

for i=1:length(orient_walks),
    walk = importfile(strcat('chest_orient_pacing/',orient_walks{i}));
    
    if simulateRespeck
        walk = walk(mod(1:size(walk,1), 8)==0, 4:6);
    end
    
    if doPCA
        [~, walk] = princomp(zscore(walk));
    end
    
    assignin('base', orient_walks{i}(1:end-4), walk)
end

respeck_walk = importfile2('chest_orient_pacing/respeckPacingSometimes.csv');
if doPCA
    [~, respeck_walk] = princomp(zscore(respeck_walk));
end
assignin('base', 'pacing4', respeck_walk)

load('chest_orient_pacing.mat')

if simulateRespeck
    pacing0R(:, 1) = pacing0R(:, 1) / 8;
    pacing1R(:, 1) = pacing1R(:, 1) / 8;
    pacing2R(:, 1) = pacing2R(:, 1) / 8;
    pacing3R(:, 1) = pacing3R(:, 1) / 8;
end

assignin('base', 'pacing0R_segs', pacing0R)
assignin('base', 'pacing1R_segs', pacing1R)
assignin('base', 'pacing2R_segs', pacing2R)
assignin('base', 'pacing3R_segs', pacing3R)
assignin('base', 'pacing4R_segs', respeckPacingSometimesR)
end

function walk = importfile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   PACING0 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   PACING0 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   pacing0 = importfile('pacing0.csv', 1, 4713);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2014/06/13 16:57:19

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%*s%*s%s%s%s%*s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
walk = cell2mat(raw);

end

function data = importfile2(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   RESPECKPACINGSOMETIMES = IMPORTFILE(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   RESPECKPACINGSOMETIMES = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads
%   data from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   respeckPacingSometimes = importfile('respeckPacingSometimes.csv', 2,
%   2179);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2014/06/22 17:50:08

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
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
data = [dataArray{1:end-1}];
end