function varySensorPair(hiddenLayers, window_size, performanceCountsTolerance)
% Script to test performance effects of varying sensor placement.
% Plots sensitivity and specificity for each sensor placement, for each
% phase of the gait.

if nargin < 1
    hiddenLayers = [10,10,10];
end
if nargin < 2
    window_size = 15;
end
if nargin <3
    performanceCountsTolerance = 0;
end

loadAlignedData('caller')

perfCounts_all_sensors = crossValidation(0,0, window_size, hiddenLayers, performanceCountsTolerance);
perfCounts_pelvis = crossValidation(0,0, window_size, hiddenLayers, performanceCountsTolerance, pelvisCols);
perfCounts_thigh = crossValidation(0,0, window_size, hiddenLayers, performanceCountsTolerance, upLegCols);
perfCounts_shin = crossValidation(0,0, window_size, hiddenLayers, performanceCountsTolerance, legCols);
perfCounts_foot = crossValidation(0,0, window_size, hiddenLayers, performanceCountsTolerance, feetCols);

[all_sensitivity, all_specificity] = getSensitivityAndSpecificityForEachClass(perfCounts_all_sensors);
[pelvis_sensitivity, pelvis_specificity] = getSensitivityAndSpecificityForEachClass(perfCounts_pelvis);
[thigh_sensitivity, thigh_specificity] = getSensitivityAndSpecificityForEachClass(perfCounts_thigh);
[shin_sensitivity, shin_specificity] = getSensitivityAndSpecificityForEachClass(perfCounts_shin);
[foot_sensitivity, foot_specificity] = getSensitivityAndSpecificityForEachClass(perfCounts_thigh);

figure
plot([all_sensitivity, pelvis_sensitivity])%, thigh_sensitivity, shin_sensitivity, foot_sensitivity])
figure;
plot([all_sensitivity, pelvis_sensitivity, thigh_sensitivity, shin_sensitivity, foot_sensitivity])

save perfSensorPlacement perfCounts_all_sensors perfCounts_thigh perfCounts_shin perfCounts_foot

end

function [classes_sensitivity, classes_specificity] = getSensitivityAndSpecificityForEachClass(sumOfPerformanceCountsByClass)
nClasses = size(sumOfPerformanceCountsByClass,1);
classes_sensitivity = zeros(nClasses, 1);
classes_specificity = zeros(nClasses, 1);
for class = 1 : nClasses
    [classes_sensitivity(class), classes_specificity(class)] = getSensitivityAndSpecificity( sumOfPerformanceCountsByClass(class,:) );
end
end