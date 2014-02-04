function plotGroundTruth(data, segments)
[X, T] = formatForNetwork(data, segments, 1, 1);
C = realignNetworkOutput(T, 1, 1, length(data));
plotClasses(data, C);
end