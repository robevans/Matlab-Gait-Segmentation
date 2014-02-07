% Script to test performance effects of varying sensor placement.
loadAlignedData

NeuralNetworkHiddenLayers = [10,10,10];
window_size = 15;

perf_all_sensors = crossValidation(0,1, window_size, NeuralNetworkHiddenLayers);
perf_thigh = crossValidation(0,1, window_size, NeuralNetworkHiddenLayers, upLegCols);
perf_shin = crossValidation(0,1, window_size, NeuralNetworkHiddenLayers, legCols);
perf_foot = crossValidation(0,1, window_size, NeuralNetworkHiddenLayers, feetCols);

save perfSensorPlacement perf_all_sensors perf_thigh perf_shin perf_foot

close all