function buildTrainTestNNAndHMM_oldFormat(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, test_data, test_segments, hidden_layers, step_size, window_size, trainFcn)
    [net, TRANS, EMIS] = trainNNAndHMM_oldFormat(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, step_size, window_size, hidden_layers, trainFcn);
    testNNAndHMM_oldFormat(net, TRANS, EMIS, test_data, test_segments, step_size, window_size);
end

function [net, TRANS_EST, EMIS_EST] = trainNNAndHMM_oldFormat(trainNN_data, trainNN_segments, trainHMM_data, trainHMM_segments, step_size, window_size, hiddenLayers, trainFcn)
    n_classes = 6;

    % Train Neural Network
    [X,T] = formatForNetwork_old(trainNN_data, trainNN_segments, step_size, window_size);
    net = patternnet(hiddenLayers,trainFcn);
    net = train(net, X, T, 'useGPU', 'yes', 'useParallel','yes');
    
    % Train Hidden Markov Model
    [X,T] = formatForNetwork_old(trainHMM_data, trainHMM_segments, step_size, window_size);
    Y = net(X);
    states = vec2ind(T);
    seq = vec2ind(Y);
    [TRANS_EST, EMIS_EST] = hmmestimate(seq, states, 'Pseudoemissions', ones(n_classes));
end

function [seq, states] = testNNAndHMM_oldFormat(net, TRANS, EMIS, test_data, test_segments, step_size, window_size)
    [X,targets] = formatForNetwork_old(test_data, test_segments, step_size, window_size);
    NN_classifications = net(X);
    perf_NN = perform(net, targets, ind2vec(vec2ind(NN_classifications)))
    classes = realignNetworkOutput(NN_classifications, step_size, window_size, length(test_data));
    plotClasses(test_data, classes);
    
    HMM_classifications = ind2vec( hmmviterbi(vec2ind(NN_classifications), TRANS, EMIS) );
    perf_HMM = perform(net, targets, HMM_classifications)
    classes = realignNetworkOutput(HMM_classifications, step_size, window_size, length(test_data));
    plotClasses(test_data, classes);
end