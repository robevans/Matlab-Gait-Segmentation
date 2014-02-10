function plotClassesAndGroundTruth(data, classes, trueSegments, window_size, error, plotTitle)

if nargin < 6
    plotTitle = 'Motion data';
end

% Create figure
screen_size = get(0,'ScreenSize');
figure1 = figure('Name',...
    'Segmentation with Neural Network and Hidden Markov Model', 'OuterPosition',[1 screen_size(4)/2 screen_size(3)/2 screen_size(4)/2]);

%% Create subplot for sensor data
subplot1 = subplot(3,1,1,'Parent',figure1,'XMinorTick','on');

box(subplot1,'on');
grid(subplot1,'on');
hold(subplot1,'all');

% Uncomment the following lines to preserve the limits of the axes
%xlim(subplot1,[32 370]);
%ylim(subplot1,[-6.89929328621908 16.7932862190813]);

% Create multiple lines using matrix input to plot
plot1 = plot(data,'Parent',subplot1);

% Create ylabel
ylabel('Rotation (deg/s)');

% Create title
title(plotTitle);

%% Create subplot for segment boundaries
subplot2 = subplot(3,1,2,'Parent',figure1,...
    'YTickLabel',{'','Heel contact','Foot flat','Heel lift','Toe off'},...
    'XMinorTick','on');

box(subplot2,'on');
grid(subplot2,'on');
hold(subplot2,'all');

% Create stem plot
stem(classes,'Parent',subplot2);

% Create title
title(strcat('Segmentation - error (', num2str(error), ')'));

% Create legend
%legend(subplot2,'show');

%% Create subplot for ground truth
subplot3 = subplot(3,1,3,'Parent',figure1,...
    'YTickLabel',{'','Heel contact','Foot flat','Heel lift','Toe off','Midswing'},...
    'XMinorTick','on');

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
xlabel('Time (frames)');

% Create title
title('Ground Truth');

% Create legend
%legend(subplot3,'show');

% Link x-axes of subplots.
linkaxes([subplot1,subplot2,subplot3], 'x');