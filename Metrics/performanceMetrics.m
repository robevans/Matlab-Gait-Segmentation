function performanceCountsByClass = performanceMetrics(targets, classifications, tolerance, nClasses)
% Assumes that class labels go from 1 to nClasses.

if nargin < 3
    tolerance = 0;
end

correctCount = 0;
incorrectCount = 0;

targets = vec2ind(targets);
classifications = vec2ind(full(classifications));

for i = 1 : length(classifications)
    if classifications(i) == targets(i)
        correctCount = correctCount + 1;
    else
        incorrectCount = incorrectCount + 1;
    end
end
accuracy = correctCount / (correctCount + incorrectCount) * 100

% Class by class performance
performanceCountsByClass = zeros(nClasses, 4);
for c = 1 : nClasses
    X = classifications == c;
    T = targets == c;
    [TP, TN, FP, FN] = performanceCountsOneClass( X, T, tolerance );
    performanceCountsByClass(c,:) = [TP, TN, FP, FN];
end

%{
totalCounts = sum(performanceCountsByClass);
TP = totalCounts(1);
TN = totalCounts(2);
FP = totalCounts(3);
FN = totalCounts(4);
sensitivity = TP / (TP + FN) * 100
specificity = TN / (FP + TN) * 100
%}

%{
TargetBoundaries = findSegmentBoundaries( targets );
ClassifiedBoundaries = findSegmentBoundaries( classifications );


TruePositives = 0;
TrueNegatives = 0;
FalsePositives = 0;
FalseNegatives = 0;
misclassifiedSegments = 0;

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
        elseif ClassifiedBoundaries(i) == 0 && TargetBoundaries(i) > 0
            FalseNegatives = FalseNegatives + 1;
        else
            misclassifiedSegments = misclassifiedSegments + 1; 
        end
    end
end

sensitivity = TruePositives / (TruePositives + FalseNegatives) * 100
specificity = TrueNegatives / (FalsePositives + TrueNegatives) * 100
misclassifiedSegments
%}

%{
TruePositives = 0;
TrueNegatives = 0;
FalsePositives = 0;
FalseNegatives = 0;
misclassifiedSegments = 0;

for i = 1 : length(ClassifiedBoundaries)
    C_window = ClassifiedBoundaries( max(1,i-tolerance) : min(length(ClassifiedBoundaries), i+tolerance) );
    T_window = TargetBoundaries( max(1,i-tolerance) : min(length(TargetBoundaries), i+tolerance) );
    
    if ClassifiedBoundaries(i) > 0 && ismember(ClassifiedBoundaries(i), T_window)
        TruePositives = TruePositives + 1;
    elseif ismember(0,C_window) && TargetBoundaries(i) == 0
        TrueNegatives = TrueNegatives + 1;
    elseif ClassifiedBoundaries(i) > 0 && ~any(T_window)
        FalsePositives = FalsePositives + 1;
    elseif ClassifiedBoundaries(i) == 0 && TargetBoundaries(i) > 0
        FalseNegatives = FalseNegatives + 1;
    else
        misclassifiedSegments = misclassifiedSegments + 1;
        ClassifiedBoundaries(i)
        C_window
        T_window
    end
end

sensitivity = TruePositives / (TruePositives + FalseNegatives) * 100
specificity = TrueNegatives / (FalsePositives + TrueNegatives) * 100
misclassifiedSegments
%}

end

function [TruePositives, TrueNegatives, FalsePositives, FalseNegatives] = performanceCountsOneClass(singleClassSegments, singleClassTargets, tolerance)
TruePositives = 0;
TrueNegatives = 0;
FalsePositives = 0;
FalseNegatives = 0;

for i = 1 : length(singleClassTargets)
    X_window = singleClassSegments( max(1,i-tolerance) : min(length(singleClassSegments), i+tolerance) );
    T_window = singleClassTargets( max(1,i-tolerance) : min(length(singleClassTargets), i+tolerance) );
    
    if singleClassTargets(i) == 1
        if ismember(1, X_window)
            TruePositives = TruePositives + 1;
        else
            FalseNegatives = FalseNegatives + 1;
        end
    elseif singleClassTargets(i) == 0
        if ismember(0, X_window)
            TrueNegatives = TrueNegatives + 1;
        else
            FalsePositives = FalsePositives + 1;
        end
    end
end

%{
TruePositives = 0;
TrueNegatives = 0;
FalsePositives = 0;
FalseNegatives = 0;
for i = 1 : length(singleClassTargets)    
    if singleClassSegments(i) == singleClassTargets(i)
        if singleClassTargets(i) > 0
            TruePositives = TruePositives + 1;
        else
            TrueNegatives = TrueNegatives + 1;
        end
    else
        if singleClassTargets(i) == 0 && singleClassSegments(i) > 0
            FalsePositives = FalsePositives + 1;
        elseif singleClassSegments(i) == 0 && singleClassTargets(i) > 0
            FalseNegatives = FalseNegatives + 1;
        end
    end
end
sensitivity = TruePositives / (TruePositives + FalseNegatives) * 100
specificity = TrueNegatives / (FalsePositives + TrueNegatives) * 100
%}

end

function labelledBoundaries = findSegmentBoundaries(labelledFrames)
% Converts an array like [1 1 1 2 2 3 3 3 4 4] into [1 0 0 2 0 3 0 0 4 0]

labelledBoundaries = zeros(length(labelledFrames),1);
labelledBoundaries(1) = labelledFrames(1);

prevFrame = labelledFrames(1);
for f = 2 : length(labelledFrames)
    if labelledFrames(f) ~= prevFrame
        labelledBoundaries(f) = labelledFrames(f);
        prevFrame = labelledFrames(f);
    end
end

end