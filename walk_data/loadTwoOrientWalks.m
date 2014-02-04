function loadTwoOrientWalks()

    walks = {'feet1.csv' 'feet2.csv' 'feet3.csv' 'shins1.csv' 'shins2.csv' 'shins3.csv' 'thighs1.csv' 'thighs2.csv' 'hips1.csv' 'hips2.csv' 'chest1.csv' 'chest2.csv'};

    for i=1:length(walks),
        [cols, L, R] = loadWalk(strcat('twoOrientWalks/',walks{i}));
        assignin('base', 'colheaders', cols)
        assignin('base', strcat(walks{i}(1:end-4),'_L'), L)
        assignin('base', strcat(walks{i}(1:end-4),'_R'), R)
    end

end

function [colheaders, left, right] = loadWalk(fileToRead1)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

% Import the file
datastruct = importdata(fileToRead1);

% Select only the columns with sensor values
selectedColumns = [5:7 9:11 13:15];

% Create return values.
colheaders = datastruct.colheaders(:, selectedColumns);
left = datastruct.data( datastruct.data(:,1)==2, selectedColumns );
right = datastruct.data( datastruct.data(:,1)==3, selectedColumns );
end