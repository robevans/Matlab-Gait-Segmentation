function loadAlignedData()

walks = {'Mxz-10.csv' 'Mxz-18.csv' 'Mxz-19.csv' 'Mxz-23.csv' 'Txz-6.csv' 'Txz-9.csv' 'Txz-12.csv' 'Txz-13.csv' 'Rxz-11.csv' 'Rxz-14.csv' 'Rxz-15.csv' 'Rxz-20.csv' 'Sxz-5.csv' 'Sxz-7.csv' 'Sxz-10.csv' 'Sxz-14.csv' 'Jxz-4.csv' 'Jxz-6.csv' 'Jxz-14.csv' 'Jxz-15.csv'};

colheaders = {'Pelvis_accel_X', 'Pelvis_accel_Y', 'Pelvis_accel_Z', 'Pelvis_gyro_X', 'Pelvis_gyro_Y', 'Pelvis_gyro_Z', 'RightUpLeg_accel_X', 'RightUpLeg_accel_Y', 'RightUpLeg_accel_Z', 'RightUpLeg_gyro_X', 'RightUpLeg_gyro_Y', 'RightUpLeg_gyro_Z', 'RightLeg_accel_X', 'RightLeg_accel_Y', 'RightLeg_accel_Z', 'RightLeg_gyro_X', 'RightLeg_gyro_Y', 'RightLeg_gyro_Z', 'RightFoot_accel_X', 'RightFoot_accel_Y', 'RightFoot_accel_Z', 'RightFoot_gyro_X', 'RightFoot_gyro_Y', 'RightFoot_gyro_Z', 'LeftUpLeg_accel_X', 'LeftUpLeg_accel_Y', 'LeftUpLeg_accel_Z', 'LeftUpLeg_gyro_X', 'LeftUpLeg_gyro_Y', 'LeftUpLeg_gyro_Z', 'LeftLeg_accel_X', 'LeftLeg_accel_Y', 'LeftLeg_accel_Z', 'LeftLeg_gyro_X', 'LeftLeg_gyro_Y', 'LeftLeg_gyro_Z', 'LeftFoot_accel_X', 'LeftFoot_accel_Y', 'LeftFoot_accel_Z', 'LeftFoot_gyro_X', 'LeftFoot_gyro_Y', 'LeftFoot_gyro_Z'};
assignin('base', 'xzCols', colheaders)
load alignedOrientSegs

for i=1:length(walks),
    data = importXZdata(strcat('./walk_data/viconAlignedWalks/',walks{i}));
    
    % Trim data that was not aligned to the Vicon system.
    if strcmp(walks{i}, 'Mxz-10.csv')
        start_frame = 195;
        data = data(start_frame:281,:);
        M10L(:,1) = M10L(:,1) - start_frame;
        M10R(:,1) = M10R(:,1) - start_frame;
        assignin('base', 'Msegs10L', M10L)
        assignin('base', 'Msegs10R', M10R)
    end
    if strcmp(walks{i}, 'Mxz-18.csv')
        start_frame = 120;
        data = data(start_frame:215,:);
        M18L(:,1) = M18L(:,1) - start_frame;
        M18R(:,1) = M18R(:,1) - start_frame;
        assignin('base', 'Msegs18L', M18L)
        assignin('base', 'Msegs18R', M18R)
    end
    if strcmp(walks{i}, 'Mxz-19.csv')
        start_frame = 121;
        data = data(start_frame:220,:);
        M19L(:,1) = M19L(:,1) - start_frame;
        M19R(:,1) = M19R(:,1) - start_frame;
        assignin('base', 'Msegs19L', M19L)
        assignin('base', 'Msegs19R', M19R)
    end
    if strcmp(walks{i}, 'Mxz-23.csv')
        start_frame = 167;
        data = data(start_frame:228,:);
        M23L(:,1) = M23L(:,1) - start_frame;
        M23R(:,1) = M23R(:,1) - start_frame;
        assignin('base', 'Msegs23L', M23L)
        assignin('base', 'Msegs23R', M23R)
    end
    if strcmp(walks{i}, 'Txz-6.csv')
        start_frame = 155;
        data = data(start_frame:240,:);
        T6L(:,1) = T6L(:,1) - start_frame;
        T6R(:,1) = T6R(:,1) - start_frame;
        assignin('base', 'Tsegs6L', T6L)
        assignin('base', 'Tsegs6R', T6R)
    end
    if strcmp(walks{i}, 'Txz-9.csv')
        start_frame = 158;
        data = data(start_frame:231,:);
        T9L(:,1) = T9L(:,1) - start_frame;
        T9R(:,1) = T9R(:,1) - start_frame;
        assignin('base', 'Tsegs9L', T9L)
        assignin('base', 'Tsegs9R', T9R)
    end
    if strcmp(walks{i}, 'Txz-12.csv')
        start_frame = 215;
        data = data(start_frame:285,:);
        T12L(:,1) = T12L(:,1) - start_frame;
        T12R(:,1) = T12R(:,1) - start_frame;
        assignin('base', 'Tsegs12L', T12L)
        assignin('base', 'Tsegs12R', T12R)
    end
    if strcmp(walks{i}, 'Txz-13.csv')
        start_frame = 139;
        data = data(start_frame:224,:);
        T13L(:,1) = T13L(:,1) - start_frame;
        T13R(:,1) = T13R(:,1) - start_frame;
        assignin('base', 'Tsegs13L', T13L)
        assignin('base', 'Tsegs13R', T13R)
    end
    if strcmp(walks{i}, 'Rxz-11.csv')
        start_frame = 212;
        data = data(start_frame:307,:);
        R11L(:,1) = R11L(:,1) - start_frame;
        R11R(:,1) = R11R(:,1) - start_frame;
        assignin('base', 'Rsegs11L', R11L)
        assignin('base', 'Rsegs11R', R11R)
    end
    if strcmp(walks{i}, 'Rxz-14.csv')
        start_frame = 243;
        data = data(start_frame:323,:);
        R14L(:,1) = R14L(:,1) - start_frame;
        R14R(:,1) = R14R(:,1) - start_frame;
        assignin('base', 'Rsegs14L', R14L)
        assignin('base', 'Rsegs14R', R14R)
    end
    if strcmp(walks{i}, 'Rxz-15.csv')
        start_frame = 226;
        data = data(start_frame:327,:);
        R15L(:,1) = R15L(:,1) - start_frame;
        R15R(:,1) = R15R(:,1) - start_frame;
        assignin('base', 'Rsegs15L', R15L)
        assignin('base', 'Rsegs15R', R15R)
    end
    if strcmp(walks{i}, 'Rxz-20.csv')
        start_frame = 267;
        data = data(start_frame:359,:);
        R20L(:,1) = R20L(:,1) - start_frame;
        R20R(:,1) = R20R(:,1) - start_frame;
        assignin('base', 'Rsegs20L', R20L)
        assignin('base', 'Rsegs20R', R20R)
    end
    if strcmp(walks{i}, 'Sxz-5.csv')
        start_frame = 192;
        data = data(start_frame:260,:);
        S5L(:,1) = S5L(:,1) - start_frame;
        S5R(:,1) = S5R(:,1) - start_frame;
        assignin('base', 'Ssegs5L', S5L)
        assignin('base', 'Ssegs5R', S5R)
    end
    if strcmp(walks{i}, 'Sxz-7.csv')
        start_frame = 160;
        data = data(start_frame:228,:);
        S7L(:,1) = S7L(:,1) - start_frame;
        S7R(:,1) = S7R(:,1) - start_frame;
        assignin('base', 'Ssegs7L', S7L)
        assignin('base', 'Ssegs7R', S7R)
    end
    if strcmp(walks{i}, 'Sxz-10.csv')
        start_frame = 126;
        data = data(start_frame:201,:);
        S10L(:,1) = S10L(:,1) - start_frame;
        S10R(:,1) = S10R(:,1) - start_frame;
        assignin('base', 'Ssegs10L', S10L)
        assignin('base', 'Ssegs10R', S10R)
    end
    if strcmp(walks{i}, 'Sxz-14.csv')
        start_frame = 131;
        data = data(start_frame:212,:);
        S14L(:,1) = S14L(:,1) - start_frame;
        S14R(:,1) = S14R(:,1) - start_frame;
        assignin('base', 'Ssegs14L', S14L)
        assignin('base', 'Ssegs14R', S14R)
    end
    if strcmp(walks{i}, 'Jxz-4.csv')
        start_frame = 177;
        data = data(start_frame:247,:);
        J4L(:,1) = J4L(:,1) - start_frame;
        J4R(:,1) = J4R(:,1) - start_frame;
        assignin('base', 'Jsegs4L', J4L)
        assignin('base', 'Jsegs4R', J4R)
    end
    if strcmp(walks{i}, 'Jxz-6.csv')
        start_frame = 191;
        data = data(start_frame:263,:);
        J6L(:,1) = J6L(:,1) - start_frame;
        J6R(:,1) = J6R(:,1) - start_frame;
        assignin('base', 'Jsegs6L', J6L)
        assignin('base', 'Jsegs6R', J6R)
    end
    if strcmp(walks{i}, 'Jxz-14.csv')
        start_frame = 149;
        data = data(start_frame:217,:);
        J14L(:,1) = J14L(:,1) - start_frame;
        J14R(:,1) = J14R(:,1) - start_frame;
        assignin('base', 'Jsegs14L', J14L)
        assignin('base', 'Jsegs14R', J14R)
    end
    if strcmp(walks{i}, 'Jxz-15.csv')
        start_frame = 159;
        data = data(start_frame:226,:);
        J15L(:,1) = J15L(:,1) - start_frame;
        J15R(:,1) = J15R(:,1) - start_frame;
        assignin('base', 'Jsegs15L', J15L)
        assignin('base', 'Jsegs15R', J15R)
    end

    assignin('base', strcat(walks{i}(1),walks{i}(5:end-4)), data)
end
end

function data = importXZdata(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   data = importXZdata(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   data = importXZdata(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   data = importXZdata('Mxz-10.csv', 9, 391);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2014/02/04 12:01:36

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
%   column23: double (%f)
%	column24: double (%f)
%   column25: double (%f)
%	column26: double (%f)
%   column27: double (%f)
%	column28: double (%f)
%   column33: double (%f)
%	column34: double (%f)
%   column35: double (%f)
%	column36: double (%f)
%   column37: double (%f)
%	column38: double (%f)
%   column43: double (%f)
%	column44: double (%f)
%   column45: double (%f)
%	column46: double (%f)
%   column47: double (%f)
%	column48: double (%f)
%   column73: double (%f)
%	column74: double (%f)
%   column75: double (%f)
%	column76: double (%f)
%   column77: double (%f)
%	column78: double (%f)
%   column83: double (%f)
%	column84: double (%f)
%   column85: double (%f)
%	column86: double (%f)
%   column87: double (%f)
%	column88: double (%f)
%   column93: double (%f)
%	column94: double (%f)
%   column95: double (%f)
%	column96: double (%f)
%   column97: double (%f)
%	column98: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%f%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%*s%f%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'ReturnOnError', false);
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