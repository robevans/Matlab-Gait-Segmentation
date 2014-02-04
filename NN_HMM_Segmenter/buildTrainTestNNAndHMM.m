function [classes, perf_HMM] = buildTrainTestNNAndHMM(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, test_data, test_segments, hidden_layers, step_size, window_size, trainFcn)
    [net, TRANS, EMIS] = trainNNAndHMM(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, step_size, window_size, hidden_layers, trainFcn);
    [classes, perf_HMM] = testNNAndHMM(net, TRANS, EMIS, test_data, test_segments, step_size, window_size);
end

function [net, HMM_TRANS_EST, HMM_EMIS_EST] = trainNNAndHMM(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, step_size, window_size, hiddenLayers, trainFcn)
    n_classes = 6;

    % Train Neural Network
    [X,T] = formatForNetwork(trainNN_data, trainNN_segments, step_size, window_size);
    net = patternnet(hiddenLayers,trainFcn);
    %net.performFcn = 'mse';
    %net.performParam.regularization = 0.01;
    
    [net, tr] = train(net, X, T, 'useGPU', 'yes', 'useParallel','yes');
    
    % Plots
    %figure, plotperform(tr)
    %figure, plottrainstate(tr)
    
    % Train Hidden Markov Model
    [X,T] = formatForNetwork(trainHMM_data, trainHMM_segments, step_size, window_size);
    Y = net(X);
    states = vec2ind(T);
    seq = vec2ind(Y);
    [HMM_TRANS_EST, HMM_EMIS_EST] = hmmestimate(seq, states, 'Pseudoemissions', ones(n_classes));
end

function [classes, perf_HMM] = testNNAndHMM(net, TRANS, EMIS, test_data, test_segments, step_size, window_size)
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
    plotClasses(test_data, classes);
end