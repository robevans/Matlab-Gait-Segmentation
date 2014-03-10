function plotClassesAndGroundTruth(data, classes, trueSegments, window_size, performanceCountsByClass, plotTitle, perfTolerance)
font_size = 20;
axes_font_size = 11;
if nargin < 6
    plotTitle = 'Motion data';
end

% Create figure
screen_size = get(0,'ScreenSize');
figure1 = figure('Name',...
    'Gait Phase Detection with Neural Network and Hidden Markov Model', 'OuterPosition',[1 screen_size(4)/2 screen_size(3)/2 screen_size(4)/2]);

%% Create subplot for sensor data
subplot1 = subplot(3,1,1,'Parent',figure1,'XMinorTick','on', 'FontSize', axes_font_size);

box(subplot1,'on');
grid(subplot1,'on');
hold(subplot1,'all');

% Uncomment the following lines to preserve the limits of the axes
%xlim(subplot1,[32 370]);
%ylim(subplot1,[-6.89929328621908 16.7932862190813]);

% Create multiple lines using matrix input to plot
plot1 = plot(data,'Parent',subplot1);

% Create ylabel
ylabel('Sensor values', 'FontSize', font_size-3);

% Create title
title(plotTitle, 'FontSize', font_size);

%% Create subplot for segment boundaries
subplot2 = subplot(3,1,2,'Parent',figure1,...
    'YTickLabel',{'','Heel strike','Foot flat','Heel off','Toe off','Midswing'},...
    'XMinorTick','on', 'FontSize', axes_font_size);

box(subplot2,'on');
grid(subplot2,'on');
hold(subplot2,'all');

% Create stem plot
stem(classes,'Parent',subplot2);

% Create title
totalCounts = sum(performanceCountsByClass);
TP = totalCounts(1);
TN = totalCounts(2);
FP = totalCounts(3);
FN = totalCounts(4);
sensitivity = TP / (TP + FN) * 100;
specificity = TN / (FP + TN) * 100;
%title( strcat('Segmentation - Performance with tolerance',{' '},num2str(perfTolerance),': sensitivity (', num2str(sensitivity), ') specificity (', num2str(specificity), ')'), 'FontSize', font_size );
title( sprintf('Detected Phases - Sensitivity: %.1f%% Specificity %.1f%% (Tolerance ±%d frames)', sensitivity, specificity, perfTolerance), 'FontSize', font_size );


% Create legend
%legend(subplot2,'show');

%% Create subplot for ground truth
subplot3 = subplot(3,1,3,'Parent',figure1,...
    'YTickLabel',{'','Heel strike','Foot flat','Heel off','Toe off','Midswing'},...
    'XMinorTick','on', 'FontSize', axes_font_size);

% Format data for plotting
[~, T] = formatForNetwork(data, trueSegments, 1, 1);
trueClasses = realignNetworkOutput(T, 1, 1, length(data));
trueClasses(1:floor(window_size/2)) = 0;
trueClasses((end-floor(window_size/2))+2:end) = 0;

box(subplot3,'on');
grid(subplot3,'on');
hold(subplot3,'all');

% Create stem plot
stem(trueClasses,'Parent',subplot3);

% Create xlabel
xlabel('Time (frames)', 'FontSize', font_size-3);

% Create title
title('Ground Truth', 'FontSize', font_size);

% Create legend
%legend(subplot3,'show');

% Link x-axes of subplots.
linkaxes([subplot1,subplot2,subplot3], 'x');