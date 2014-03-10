function tolerancesSensitivitySpecificity = varyTolerances(maxTolerance, hiddenLayers, window_size)
% Plots the effect on performance (sensitivity and specificity) of varying
% the tolerance when calculating performance metrics.  e.g. with a
% tolerance of 1, gait phase classifications will be treated as correct
% even if they are 1 frame away from the true answer.

if nargin < 1
    maxTolerance = 10;
end
if nargin < 2
    hiddenLayers = [10,10,10];
end
if nargin < 3
    window_size = 15;
end

for t = 0 : maxTolerance
    sumPerfCountsByClass = crossValidation(0,0,window_size,hiddenLayers,t);
    sumAllPerfCounts = sum(sumPerfCountsByClass);
    TP = sumAllPerfCounts(1);
    TN = sumAllPerfCounts(2);
    FP = sumAllPerfCounts(3);
    FN = sumAllPerfCounts(4);
    average_sensitivity = TP / (TP + FN) * 100
    average_specificity = TN / (FP + TN) * 100
    tolerancesSensitivitySpecificity(t+1,:) = [average_sensitivity, average_specificity];
end

createfigure(0:maxTolerance, tolerancesSensitivitySpecificity);
set(gcf,'PaperPositionMode','auto');
set(gcf,'PaperOrientation','landscape');
set(gcf,'Position',[50 50 1200 800]);
print( strcat('./Graphs/tolerancePerformance'), '-dpdf')

save perf_tolerances tolerancesSensitivitySpecificity

end

function createfigure(Xs1, YMatrix1)
%CREATEFIGURE2(XS1, YMATRIX1)
%  XS1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 11-Feb-2014 02:59:38

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'FontSize',17);
%% Uncomment the following line to preserve the limits of the axes
ylim(axes1,[75 100]);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(Xs1,YMatrix1,'Parent',axes1,'LineWidth',4);
set(plot1(1),'DisplayName','Sensitivity');
set(plot1(2),'DisplayName','Specificity');

% Create xlabel
xlabel('Tolerance (� n frames)','FontSize',18);

% Create ylabel
ylabel('Specificity/Sensitivity (%)','FontSize',18);

% Create title
title('Effect On Sensitivity And Specificity As Classification Tolerance Increases',...
    'FontSize',20);

% Create legend
legend1 = legend(axes1,'show','Location','SouthEast');
set(legend1,'FontSize',20);

end