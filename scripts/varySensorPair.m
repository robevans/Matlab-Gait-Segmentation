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

% Generate performance data
[allSn,allSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, allCols);
[pelSn,pelSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, pelvisCols);
[thiSn,thiSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, upLegCols);
[shiSn,shiSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, legCols);
[fooSn,fooSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, feetCols);

[allAcSn,allAcSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, allAccelCols);
[pelAcSn,pelAcSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, pelvisAccelCols);
[thiAcSn,thiAcSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, upLegAccelCols);
[shiAcSn,shiAcSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, legAccelCols);
[fooAcSn,fooAcSp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, feetAccelCols);

[allGySn,allGySp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, allGyroCols);
[pelGySn,pelGySp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, pelvisGyroCols);
[thiGySn,thiGySp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, upLegGyroCols);
[shiGySn,shiGySp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, legGyroCols);
[fooGySn,fooGySp] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, feetGyroCols);

% Create figures
createAndSaveFigure([allSn,pelSn,thiSn,shiSn,fooSn],strcat('Sensor placement Sensitivity with Accel + Gyro data (Tolerance',{' '},num2str(performanceCountsTolerance),')'),'Sensitivity (%)',{'All','Pelvis','Thighs','Legs','Feet'},['SensitivityAccelGyroTolerance' num2str(performanceCountsTolerance)])
createAndSaveFigure([allSp,pelSp,thiSp,shiSp,fooSp],strcat('Sensor placement Specificity with Accel + Gyro data, (Tolerance',{' '},num2str(performanceCountsTolerance),')'),'Specificity (%)',{'All','Pelvis','Thighs','Legs','Feet'},['SpecificityAccelGyroTolerance' num2str(performanceCountsTolerance)])

createAndSaveFigure([allAcSn,pelAcSn,thiAcSn,shiAcSn,fooAcSn],strcat('Sensor placement Sensitivity with Accel data, (Tolerance',{' '},num2str(performanceCountsTolerance),')'),'Sensitivity (%)',{'All','Pelvis','Thighs','Legs','Feet'},['SensitivityAccelTolerance' num2str(performanceCountsTolerance)])
createAndSaveFigure([allAcSp,pelAcSp,thiAcSp,shiAcSp,fooAcSp],strcat('Sensor placement Specificity with Accel data, (Tolerance',{' '},num2str(performanceCountsTolerance),')'),'Specificity (%)',{'All','Pelvis','Thighs','Legs','Feet'},['SpecificityAccelTolerance' num2str(performanceCountsTolerance)])

createAndSaveFigure([allGySn,pelGySn,thiGySn,shiGySn,fooGySn],strcat('Sensor placement Sensitivity with Gyro data, (Tolerance',{' '},num2str(performanceCountsTolerance),')'),'Sensitivity (%)',{'All','Pelvis','Thighs','Legs','Feet'},['SensitivityGyroTolerance' num2str(performanceCountsTolerance)])
createAndSaveFigure([allGySp,pelGySp,thiGySp,shiGySp,fooGySp],strcat('Sensor placement Specificity with Gyro data, (Tolerance',{' '},num2str(performanceCountsTolerance),')'),'Specificity (%)',{'All','Pelvis','Thighs','Legs','Feet'},['SpecificityGyroTolerance' num2str(performanceCountsTolerance)])

save( ['placementsTolerance' num2str(performanceCountsTolerance)], 'allSn', 'allSp', 'pelSn', 'pelSp', 'thiSn', 'thiSp', 'shiSn', 'shiSp', 'fooSn', 'fooSp', 'allAcSn', 'allAcSp', 'pelAcSn', 'pelAcSp', 'thiAcSn', 'thiAcSp', 'shiAcSn', 'shiAcSp', 'fooAcSn', 'fooAcSp', 'allGySn', 'allGySp', 'pelGySn', 'pelGySp', 'thiGySn', 'thiGySp', 'shiGySn', 'shiGySp', 'fooGySn', 'fooGySp')

end

function crossValidateEvaluateAndPlotOneData(window_size, hiddenLayers, performanceCountsTolerance, data_columns, plotTitle)
perfCounts = crossValidation(0,0, window_size, hiddenLayers, performanceCountsTolerance, data_columns);
[sensitivity, specificity] = getSensitivityAndSpecificityForEachClass(perfCounts);
createAndSaveFigure(sensitivity, plotTitle, 'Sensitivity (%)',0,plotTitle)
createAndSaveFigure(specificity, plotTitle, 'Specificity (%)',0,plotTitle)
end

function [sensitivity, specificity] = crossValidateAndEvaluate(window_size, hiddenLayers, performanceCountsTolerance, data_columns)
perfCounts = crossValidation(0,0, window_size, hiddenLayers, performanceCountsTolerance, data_columns);
[sensitivity, specificity] = getSensitivityAndSpecificityForEachClass(perfCounts);
end

function [classes_sensitivity, classes_specificity] = getSensitivityAndSpecificityForEachClass(sumOfPerformanceCountsByClass)
nClasses = size(sumOfPerformanceCountsByClass,1);
classes_sensitivity = zeros(nClasses, 1);
classes_specificity = zeros(nClasses, 1);
for class = 1 : nClasses
    [classes_sensitivity(class), classes_specificity(class)] = getSensitivityAndSpecificity( sumOfPerformanceCountsByClass(class,:) );
end
end

function createAndSaveFigure(YMatrix1, titleString, yLabelString, legend, savedFigFilename)
createfigure(YMatrix1, titleString, yLabelString, legend)
set(gcf,'PaperPositionMode','auto');
set(gcf,'PaperOrientation','landscape');
set(gcf,'Position',[50 50 1200 800]);
print( strcat('./Graphs/Sensor Pair/',savedFigFilename), '-dpdf')
end

function createfigure(YMatrix1, titleString, yLabelString, legend_labels)
%CREATEFIGURE1(YMATRIX1)
%  YMATRIX1:  matrix of y data

if nargin < 4
    legend_labels = {}; % Should be a cell array of strings
end

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'Heel Contact','Foot Flat','Heel Lift','Toe Off','Mid swing'},...
    'XTick',[1 2 3 4 5],...
    'FontSize',12);
%% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[0.8 5.2]);
ylim(axes1,[0 100]);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(YMatrix1,'Parent',axes1);
if ~isempty(legend_labels)
    for i = 1 : length(legend_labels)
        set(plot1(i), 'DisplayName', legend_labels{i});
    end
end

% Create xlabel
xlabel('Gait Phases','FontSize',14);

% Create ylabel
ylabel(yLabelString,'FontSize',14);

% Create title
title(titleString,'FontSize',14);

% Create legend
if ~isempty(legend_labels)
    legend1 = legend(axes1,'show');
    set(legend1,'FontSize',14);
end
end
