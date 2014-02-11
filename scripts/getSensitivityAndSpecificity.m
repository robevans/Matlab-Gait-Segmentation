function [sensitivity, specificity] = getSensitivityAndSpecificity(performanceCounts)
TP = performanceCounts(1);
TN = performanceCounts(2);
FP = performanceCounts(3);
FN = performanceCounts(4);
sensitivity = TP / (TP + FN) * 100;
specificity = TN / (FP + TN) * 100;
end