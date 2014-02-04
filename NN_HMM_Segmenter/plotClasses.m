function plotClasses(data, classes)
% Create figure
screen_size = get(0,'ScreenSize');
figure1 = figure('Name',...
    'Segmentation with Neural Network and Hidden Markov Model', 'OuterPosition',[1 screen_size(4)/2 screen_size(3)/2 screen_size(4)/2]);

% Create subplot for sensor data
subplot1 = subplot(2,1,1,'Parent',figure1,'XMinorTick','on');

box(subplot1,'on');
grid(subplot1,'on');
hold(subplot1,'all');

%% Uncomment the following lines to preserve the limits of the axes
%xlim(subplot1,[32 370]);
%ylim(subplot1,[-6.89929328621908 16.7932862190813]);

% Create multiple lines using matrix input to plot
plot1 = plot(data,'Parent',subplot1);

% Create ylabel
ylabel('Rotation (deg/s)');

% Create title
title({'Left Leg and Pelvis Gyroscope Data (Four Sensors)'});

% Create subplot for segment boundaries
subplot2 = subplot(2,1,2,'Parent',figure1,...
    'YTickLabel',{'','Heel-off to Toe-off','Toe-off to Midswing','Midswing to Heel-strike','Heel-strike to Toe-down','Toe-down to Midstance','Midstance to Heel-off'},...
    'XMinorTick','on');

box(subplot2,'on');
grid(subplot2,'on');
hold(subplot2,'all');

% Create stem plot
stem(classes,'Parent',subplot2);

% Create xlabel
xlabel('Time (frames)');

% Create title
title('Automatic segmentation');

% Create legend
%legend(subplot1,'show');

% Link x-axes of subplots.
linkaxes([subplot1,subplot2], 'x');