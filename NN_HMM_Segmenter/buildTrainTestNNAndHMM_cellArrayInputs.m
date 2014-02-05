function [classes, perf_HMM] = buildTrainTestNNAndHMM_cellArrayInputs(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, test_data, test_segments, hidden_layers, step_size, window_size, trainFcn, plotTitle)
% Trains and tests the gait segmenter.  Each of the training data arguments
% should be a cell array.
    [net, TRANS, EMIS] = trainNNAndHMM(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, step_size, window_size, hidden_layers, trainFcn);
    [classes, perf_HMM] = testNNAndHMM(net, TRANS, EMIS, test_data, test_segments, step_size, window_size, plotTitle);
end

function [net, HMM_TRANS_EST, HMM_EMIS_EST] = trainNNAndHMM(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, step_size, window_size, hiddenLayers, trainFcn)

    %% Train Neural Network
    [Xs,Ts] = formatMultipleDataForNN(trainNN_data, trainNN_segments, step_size, window_size);
    net = patternnet(hiddenLayers,trainFcn);
    
    [net, tr] = train(net, Xs, Ts, 'useGPU', 'yes', 'useParallel','yes');
    
    % Plots
    %figure, plotperform(tr)
    %figure, plottrainstate(tr)
    
    %% Train Hidden Markov Model
    nClasses = 4;
    
    % Manually count all but one of the HMM training datas.
    TRANS_COUNTS = zeros(nClasses);
    EMIS_COUNTS = ones(nClasses); % Add one smoothing to allow for any emmission (classification errors).
    for i = 2 : length(trainHMM_data)
        [X,states] = formatForNetwork(trainHMM_data{i}, trainHMM_segments{i}, step_size, window_size);
        emissions = net(X);
        [t, c] = HMM_training_counts(vec2ind(emissions), vec2ind(states), nClasses);
    end
    
    % Train HMM on one dataset, but pass in the extra counts.
    [X,states] = formatForNetwork(trainHMM_data{1}, trainHMM_segments{1}, step_size, window_size);
    emissions = net(X);
    [HMM_TRANS_EST, HMM_EMIS_EST] = hmmestimate(vec2ind(emissions), vec2ind(states), 'Pseudotransitions', TRANS_COUNTS, 'Pseudoemissions', EMIS_COUNTS);
end

function [classes, perf_HMM] = testNNAndHMM(net, TRANS, EMIS, test_data, test_segments, step_size, window_size, plotTitle)
    [X,targets] = formatForNetwork(test_data, test_segments, step_size, window_size);
    NN_classifications = net(X);
    %perf_NN = perform(net, targets, ind2vec(vec2ind(NN_classifications)))
    classes = realignNetworkOutput(NN_classifications, step_size, window_size, length(test_data));
    %plotClasses(test_data, classes);
    
    HMM_classifications = ind2vec( hmmviterbi(vec2ind(NN_classifications), TRANS, EMIS) );
    
    %perf_HMM = perform(net, targets, HMM_classifications)
    perf_HMM = mse(net, targets, HMM_classifications)
    
    %errors = gsubtract(targets, HMM_classifications);
    %figure, plotconfusion(targets, HMM_classifications)
    %figure, ploterrhist(errors)
    
    classes = realignNetworkOutput(HMM_classifications, step_size, window_size, length(test_data));
    plotClassesAndGroundTruth(test_data, classes, test_segments, window_size, plotTitle);
end

function [Xs, Ts] = formatMultipleDataForNN(dataCells, segmentCells, step_size, window_size)

for i = 1 : length(dataCells)
    [X{i}, T{i}] = formatForNetwork(dataCells{i}, segmentCells{i}, step_size, window_size);
end

Xs = horzcat(X{:});
Ts = horzcat(T{:});
end

function [TRANS_COUNTS, EMIS_COUNTS] = HMM_training_counts(seq, states, nClasses)
TRANS_COUNTS = zeros(nClasses);
EMIS_COUNTS = zeros(nClasses);

if length(seq) == length(states)
    
    for i = 1 : length(states) - 1
        TRANS_COUNTS(states(i),states(i+1)) = TRANS_COUNTS(states(i),states(i+1)) + 1;
    end
    
    for i = 1 : length(states)
        EMIS_COUNTS(states(i),seq(i)) = EMIS_COUNTS(states(i),seq(i)) + 1;
    end
    
end
end