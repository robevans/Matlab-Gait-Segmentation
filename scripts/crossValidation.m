function average_performance = doCrossValidation(showPlots, savePlots, window_size, hiddenLayers, data_columns)
%Does cross validation for Vicon aligned Orient data.

if nargin < 5
    data_columns = 1:42;
end

closePlotAfterSaving = false;
if savePlots && ~showPlots
    showPlots = true;
    closePlotAfterSaving = true;
end

% Model parameters
%hiddenLayers = [10,10,10];
step_size = 1;
%window_size = 1;

% Ready the data
loadAlignedData('caller');
titles = {'M10' 'M18' 'M19' 'M23' 'T6' 'T9' 'T12' 'T13' 'R11' 'R14' 'R15' 'R20' 'S5' 'S7' 'S10' 'S14' 'J4' 'J6' 'J14' 'J15'};
data = {M10 M18 M19 M23 T6 T9 T12 T13 R11 R14 R15 R20 S5 S7 S10 S14 J4 J6 J14 J15};
Lsegs = {Msegs10L Msegs18L Msegs19L Msegs23L Tsegs6L Tsegs9L Tsegs12L Tsegs13L Rsegs11L Rsegs14L Rsegs15L Rsegs20L Ssegs5L Ssegs7L Ssegs10L Ssegs14L Jsegs4L Jsegs6L Jsegs14L Jsegs15L};
Rsegs = {Msegs10R Msegs18R Msegs19R Msegs23R Tsegs6R Tsegs9R Tsegs12R Tsegs13R Rsegs11R Rsegs14R Rsegs15R Rsegs20R Ssegs5R Ssegs7R Ssegs10R Ssegs14R Jsegs4R Jsegs6R Jsegs14R Jsegs15R};

for i = 1 : length(titles)
    data{i} = data{i}(:,data_columns);
end

sum_performance = 0;

% Leave-one-out cross validation
for i = 1 : length(data)
    
    train_index = 1 : length(data);
    train_index(i) = [];
    train_data = data(train_index);
    train_Lsegs = Lsegs(train_index);
    train_Rsegs = Rsegs(train_index);
    
    test_data = data{i};
    test_Lsegs = Lsegs{i};
    test_Rsegs = Rsegs{i};
    
    [~, perfL] = buildTrainTestNNAndHMM_cellArrayInputs(train_data, train_Lsegs, train_data, train_Lsegs, test_data, test_Lsegs, hiddenLayers, step_size, window_size, 'trainscg', strcat('Left Leg Segments - capture ',{' '},titles{i}), showPlots);
    if savePlots
        print( strcat('./Graphs/CrossVal/',titles{i},'L'), '-dpdf')
        if closePlotAfterSaving
            close
        end
    end
    [~, perfR] = buildTrainTestNNAndHMM_cellArrayInputs(train_data, train_Rsegs, train_data, train_Rsegs, test_data, test_Rsegs, hiddenLayers, step_size, window_size, 'trainscg', strcat('Right Leg Segments - capture ',{' '},titles{i}), showPlots);
    if savePlots
        print( strcat('./Graphs/CrossVal/',titles{i},'R'), '-dpdf')
        if closePlotAfterSaving
            close
        end
    end
    
    sum_performance = sum_performance + perfL + perfR;
end

average_performance = sum_performance / (length(data) * 2);
end