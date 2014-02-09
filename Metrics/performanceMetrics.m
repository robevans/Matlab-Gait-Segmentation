function performanceMetrics(targets, classifications, tolerance)

if nargin < 3
    tolerance = 0;
end

TargetBoundaries = findSegmentBoundaries( vec2ind(targets) );
ClassifiedBoundaries = findSegmentBoundaries( vec2ind(full(classifications)) );


TruePositives = 0;
TrueNegatives = 0;
FalsePositives = 0;
FalseNegatives = 0;

for i = 1 : length(TargetBoundaries)
    if ClassifiedBoundaries(i) == TargetBoundaries(i)
        if TargetBoundaries(i) > 0
            TruePositives = TruePositives + 1;
        else
            TrueNegatives = TrueNegatives + 1;
        end
    else
        if TargetBoundaries(i) == 0 && ClassifiedBoundaries(i) > 0
            FalsePositives = FalsePositives + 1;
        else
            FalseNegatives = FalseNegatives + 1;
        end
    end
end

sensitivity = TruePositives / (TruePositives + FalseNegatives) * 100
specificity = TrueNegatives / (FalsePositives + TrueNegatives) * 100

end

function labelledBoundaries = findSegmentBoundaries(labelledFrames)
% Converts an array like [1 1 1 2 2 3 3 3 4 4] into [1 0 0 2 0 3 0 0 4 0]

labelledBoundaries = zeros(length(labelledFrames),1);
labelledBoundaries(1) = labelledFrames(1);

prevFrame = labelledFrames(1);
for i = 2 : length(labelledFrames)
    if labelledFrames(i) ~= prevFrame
        labelledBoundaries(i) = labelledFrames(i);
        prevFrame = labelledFrames(i);
    end
end

end