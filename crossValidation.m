% Model parameters
hiddenLayers = [10,10,10];
step_size = 1;
window_size = 10;

% Ready the data
loadAlignedData
titles = {'M10' 'M18' 'M19' 'M23' 'T6' 'T9' 'T12' 'T13' 'R11' 'R14' 'R15' 'R20' 'S5' 'S7' 'S10' 'S14' 'J4' 'J6' 'J14' 'J15'};
data = {M10 M18 M19 M23 T6 T9 T12 T13 R11 R14 R15 R20 S5 S7 S10 S14 J4 J6 J14 J15};
Lsegs = {Msegs10L Msegs18L Msegs19L Msegs23L Tsegs6L Tsegs9L Tsegs12L Tsegs13L Rsegs11L Rsegs14L Rsegs15L Rsegs20L Ssegs5L Ssegs7L Ssegs10L Ssegs14L Jsegs4L Jsegs6L Jsegs14L Jsegs15L};
Rsegs = {Msegs10R Msegs18R Msegs19R Msegs23R Tsegs6R Tsegs9R Tsegs12R Tsegs13R Rsegs11R Rsegs14R Rsegs15R Rsegs20R Ssegs5R Ssegs7R Ssegs10R Ssegs14R Jsegs4R Jsegs6R Jsegs14R Jsegs15R};

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
    
    buildTrainTestNNAndHMM_cellArrayInputs(train_data, train_Lsegs, train_data, train_Lsegs, test_data, test_Lsegs, hiddenLayers, step_size, window_size, 'trainscg', strcat('Left Leg Segments - capture ',{' '},titles{i}));
    buildTrainTestNNAndHMM_cellArrayInputs(train_data, train_Rsegs, train_data, train_Rsegs, test_data, test_Rsegs, hiddenLayers, step_size, window_size, 'trainscg', strcat('Right Leg Segments - capture ',{' '},titles{i}));
end