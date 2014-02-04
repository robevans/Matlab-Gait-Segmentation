function plotGroundTruth(data, segments)
% This function formats the segments as if they were output by the
% automatic segmenter, and displays them in the same style.
%   Example: plotGroundTruth(M10, Msegs10R)
[~, T] = formatForNetwork(data, segments, 1, 1);
C = realignNetworkOutput(T, 1, 1, length(data));
plotClasses(data, C);
end