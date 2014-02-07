% Script to test performance of varying window size parameter.

NeuralNetworkHiddenLayers = [10,10,10];

min_window_size = 1;
window_increment_size = 1;
max_window_size = 50;

perf_windows = nan(max_window_size,1);

for window_size = min_window_size : window_increment_size : max_window_size
   perf_windows(window_size) = crossValidation(0,0, window_size, NeuralNetworkHiddenLayers);
end

bar(perf_windows)

save perfWindows perf_windows