function alignedDataMetrics(window_size, hiddenLayers, performanceCountsTolerance, data_columns)
fps = 42.666668;

if nargin > 0
    subjects_crossValidation(0,0,window_size, hiddenLayers, performanceCountsTolerance, data_columns);
end

load crossValidationClasses
% Get data indexes for each subject
M = [findIndex('M10',titles) findIndex('M18',titles) findIndex('M19',titles) findIndex('M23',titles)];
T = [findIndex('T6',titles) findIndex('T9',titles) findIndex('T12',titles) findIndex('T13',titles)];
R = [findIndex('R11',titles) findIndex('R14',titles) findIndex('R15',titles) findIndex('R20',titles)];
S = [findIndex('S5',titles) findIndex('S7',titles) findIndex('S10',titles) findIndex('S14',titles)];
J = [findIndex('J4',titles) findIndex('J6',titles) findIndex('J14',titles) findIndex('J15',titles)];

averagePhaseTimesScatterPlot(M, T, R, S, J, Lclasses, Rclasses, fps);
printCurrentFigureToFile('allGaitPhasesScatter')
averageSwingStanceScatterPlot(M, T, R, S, J, Lclasses, Rclasses, fps);
printCurrentFigureToFile('swingStanceScatter')
cycleTimeMetrics(M, T, R, S, J, Lclasses, Rclasses, fps);

end

function cycleTimeMetrics(M, T, R, S, J, Lclasses, Rclasses, fps)
M_phaseTimesL = swingStanceSizes(Lclasses(M))/fps;
M_phaseTimesR = swingStanceSizes(Rclasses(M))/fps;
T_phaseTimesL = swingStanceSizes(Lclasses(T))/fps;
T_phaseTimesR = swingStanceSizes(Rclasses(T))/fps;
R_phaseTimesL = swingStanceSizes(Lclasses(R))/fps;
R_phaseTimesR = swingStanceSizes(Rclasses(R))/fps;
S_phaseTimesL = swingStanceSizes(Lclasses(S))/fps;
S_phaseTimesR = swingStanceSizes(Rclasses(S))/fps;
J_phaseTimesL = swingStanceSizes(Lclasses(J))/fps;
J_phaseTimesR = swingStanceSizes(Rclasses(J))/fps;

M_cycle_time = ( (sum(M_phaseTimesL) + sum(M_phaseTimesR)) / 2 );
T_cycle_time = ( (sum(T_phaseTimesL) + sum(T_phaseTimesR)) / 2 );
R_cycle_time = ( (sum(R_phaseTimesL) + sum(R_phaseTimesR)) / 2 );
S_cycle_time = ( (sum(S_phaseTimesL) + sum(S_phaseTimesR)) / 2 );
J_cycle_time = ( (sum(J_phaseTimesL) + sum(J_phaseTimesR)) / 2 );

M_steps_per_minute = 60 / M_cycle_time;
T_steps_per_minute = 60 / T_cycle_time;
R_steps_per_minute = 60 / R_cycle_time;
S_steps_per_minute = 60 / S_cycle_time;
J_steps_per_minute = 60 / J_cycle_time;

M_duty_swingL = M_phaseTimesL(1);
M_duty_stanceL = M_phaseTimesL(2);
M_duty_swingR = M_phaseTimesL(1);
M_duty_stanceR = M_phaseTimesL(2);
T_duty_swingL = T_phaseTimesL(1);
T_duty_stanceL = T_phaseTimesL(2);
T_duty_swingR = T_phaseTimesL(1);
T_duty_stanceR = T_phaseTimesL(2);
R_duty_swingL = R_phaseTimesL(1);
R_duty_stanceL = R_phaseTimesL(2);
R_duty_swingR = R_phaseTimesL(1);
R_duty_stanceR = R_phaseTimesL(2);
S_duty_swingL = S_phaseTimesL(1);
S_duty_stanceL = S_phaseTimesL(2);
S_duty_swingR = S_phaseTimesL(1);
S_duty_stanceR = S_phaseTimesL(2);
J_duty_swingL = J_phaseTimesL(1);
J_duty_stanceL = J_phaseTimesL(2);
J_duty_swingR = J_phaseTimesL(1);
J_duty_stanceR = J_phaseTimesL(2);

M_stance_ratioL = M_phaseTimesL(2) / sum(M_phaseTimesL);
M_stance_ratioR = M_phaseTimesR(2) / sum(M_phaseTimesR);
T_stance_ratioL = T_phaseTimesL(2) / sum(T_phaseTimesL);
T_stance_ratioR = T_phaseTimesR(2) / sum(T_phaseTimesR);
R_stance_ratioL = R_phaseTimesL(2) / sum(R_phaseTimesL);
R_stance_ratioR = R_phaseTimesR(2) / sum(R_phaseTimesR);
S_stance_ratioL = S_phaseTimesL(2) / sum(S_phaseTimesL);
S_stance_ratioR = S_phaseTimesR(2) / sum(S_phaseTimesR);
J_stance_ratioL = J_phaseTimesL(2) / sum(J_phaseTimesL);
J_stance_ratioR = J_phaseTimesR(2) / sum(J_phaseTimesR);

M_avg_stance_ratio = (M_stance_ratioL + M_stance_ratioR) / 2;
T_avg_stance_ratio = (T_stance_ratioL + T_stance_ratioR) / 2;
R_avg_stance_ratio = (R_stance_ratioL + R_stance_ratioR) / 2;
S_avg_stance_ratio = (S_stance_ratioL + S_stance_ratioR) / 2;
J_avg_stance_ratio = (J_stance_ratioL + J_stance_ratioR) / 2;

fprintf('Subject\t\tCycle Time\t\tSteps per min\tLeft Stance Ratio\tRight Stance Ratio\tAverage Stance Ratio\n');
fprintf('M\t\t\t%.2f\t\t\t%.2f\t\t\t%.2f\t\t\t\t%.2f\t\t\t\t%.2f\n',M_cycle_time,M_steps_per_minute,M_stance_ratioL,M_stance_ratioR,M_avg_stance_ratio);
fprintf('T\t\t\t%.2f\t\t\t%.2f\t\t\t%.2f\t\t\t\t%.2f\t\t\t\t%.2f\n',T_cycle_time,T_steps_per_minute,T_stance_ratioL,T_stance_ratioR,T_avg_stance_ratio);
fprintf('R\t\t\t%.2f\t\t\t%.2f\t\t\t%.2f\t\t\t\t%.2f\t\t\t\t%.2f\n',R_cycle_time,R_steps_per_minute,R_stance_ratioL,R_stance_ratioR,R_avg_stance_ratio);
fprintf('S\t\t\t%.2f\t\t\t%.2f\t\t\t%.2f\t\t\t\t%.2f\t\t\t\t%.2f\n',S_cycle_time,S_steps_per_minute,S_stance_ratioL,S_stance_ratioR,S_avg_stance_ratio);
fprintf('J\t\t\t%.2f\t\t\t%.2f\t\t\t%.2f\t\t\t\t%.2f\t\t\t\t%.2f\n',J_cycle_time,J_steps_per_minute,J_stance_ratioL,J_stance_ratioR,J_avg_stance_ratio);

end

function printCurrentFigureToFile(filename)
set(gcf,'PaperPositionMode','auto');
set(gcf,'PaperOrientation','landscape');
set(gcf,'Position',[50 50 1200 800]);
print( strcat('./Graphs/Metrics for Aligned Data/',filename), '-dpdf')
end

function averageSwingStanceScatterPlot(M, T, R, S, J, Lclasses, Rclasses, fps)
% Average gait phase times for each subject by leg
M_phaseTimesL = swingStanceSizes(Lclasses(M))/fps;
M_phaseTimesR = swingStanceSizes(Rclasses(M))/fps;
T_phaseTimesL = swingStanceSizes(Lclasses(T))/fps;
T_phaseTimesR = swingStanceSizes(Rclasses(T))/fps;
R_phaseTimesL = swingStanceSizes(Lclasses(R))/fps;
R_phaseTimesR = swingStanceSizes(Rclasses(R))/fps;
S_phaseTimesL = swingStanceSizes(Lclasses(S))/fps;
S_phaseTimesR = swingStanceSizes(Rclasses(S))/fps;
J_phaseTimesL = swingStanceSizes(Lclasses(J))/fps;
J_phaseTimesR = swingStanceSizes(Rclasses(J))/fps;

% Format plot
F = figure;
A = axes('Parent',F,'FontSize',30);
xlim(A,[0 0.75]);
ylim(A,[0 0.75]);
%title('Swing/Stance Duration Asymmetries (colour coded by subject)','FontSize',25);
xlabel('Left Swing/Stance Duration (seconds)','FontSize',30);
ylabel('Right Swing/Stance Duration (seconds)','FontSize',30);

% Plot data
hold on;
pointSize = 130;
scatter(M_phaseTimesL(1), M_phaseTimesR(1), pointSize, 'k', 'o', 'fill');
scatter(M_phaseTimesL(2), M_phaseTimesR(2), pointSize, 'k', 's', 'fill');
scatter(T_phaseTimesL(1), T_phaseTimesR(1), pointSize, 'g', 'o', 'fill');
scatter(T_phaseTimesL(2), T_phaseTimesR(2), pointSize, 'g', 's', 'fill');
scatter(R_phaseTimesL(1), R_phaseTimesR(1), pointSize, 'c', 'o', 'fill');
scatter(R_phaseTimesL(2), R_phaseTimesR(2), pointSize, 'c', 's', 'fill');
scatter(S_phaseTimesL(1), S_phaseTimesR(1), pointSize, 'r', 'o', 'fill');
scatter(S_phaseTimesL(2), S_phaseTimesR(2), pointSize, 'r', 's', 'fill');
scatter(J_phaseTimesL(1), J_phaseTimesR(1), pointSize, 'b', 'o', 'fill');
scatter(J_phaseTimesL(2), J_phaseTimesR(2), pointSize, 'b', 's', 'fill');
topCorner = max ( get(gca,'xlim'), get(gca,'ylim') );
plot([0,topCorner],[0,topCorner],'LineWidth',4);
hold off;

% Show legend
L = legend('Swing','Stance','Location','SouthEast');
set(L,'FontSize',33);
M = findobj(L,'type','patch'); % Find objects of type 'patch' (the marker points in the legend)
set(M,'MarkerSize', sqrt(pointSize)) %Calculate marker size based on size of scatter points
end

function averagePhaseTimesScatterPlot(M, T, R, S, J, Lclasses, Rclasses, fps)
% Average gait phase times for each subject by leg
M_phaseTimesL = averageSegmentSizes(Lclasses(M))/fps;
M_phaseTimesR = averageSegmentSizes(Rclasses(M))/fps;
T_phaseTimesL = averageSegmentSizes(Lclasses(T))/fps;
T_phaseTimesR = averageSegmentSizes(Rclasses(T))/fps;
R_phaseTimesL = averageSegmentSizes(Lclasses(R))/fps;
R_phaseTimesR = averageSegmentSizes(Rclasses(R))/fps;
S_phaseTimesL = averageSegmentSizes(Lclasses(S))/fps;
S_phaseTimesR = averageSegmentSizes(Rclasses(S))/fps;
J_phaseTimesL = averageSegmentSizes(Lclasses(J))/fps;
J_phaseTimesR = averageSegmentSizes(Rclasses(J))/fps;

% Format plot
F = figure;
A = axes('Parent',F,'FontSize',30);
xlim(A,[0 0.75]);
ylim(A,[0 0.75]);
%title('Gait Phase Duration Asymmetries (colour coded by subject)','FontSize',25);
xlabel('Left Gait Phase Duration (seconds)','FontSize',30);
ylabel('Right Gait Phase Duration (seconds)','FontSize',30);

% Plot data
hold on;
pointSize = 150;
scatterHelper(M_phaseTimesL, M_phaseTimesR, pointSize, 'k');
scatterHelper(T_phaseTimesL, T_phaseTimesR, pointSize, 'g');
scatterHelper(R_phaseTimesL, R_phaseTimesR, pointSize, 'c');
scatterHelper(S_phaseTimesL, S_phaseTimesR, pointSize, 'r');
scatterHelper(J_phaseTimesL, J_phaseTimesR, pointSize, 'b');
topCorner = min ( get(gca,'xlim'), get(gca,'ylim') );
plot([0,topCorner],[0,topCorner],'LineWidth',4);
hold off;

% Show legend
L = legend('Heel Strike - Foot Flat','Foot Flat - Heel Off','Heel Off - Toe Off','Toe Off - Mid Swing','Mid Swing - Heel Strike','Location','SouthEast');
set(L,'FontSize',33);
M = findobj(L,'type','patch'); % Find objects of type 'patch' (the marker points in the legend)
set(M,'MarkerSize', sqrt(pointSize)) %Calculate marker size based on size of scatter points
end

function scatterHelper(Ldata, Rdata, pointSize, colour)
scatter(Ldata(1), Rdata(1), pointSize, colour, 'o', 'fill');
scatter(Ldata(2), Rdata(2), pointSize, colour, 'h', 'fill');
scatter(Ldata(3), Rdata(3), pointSize, colour, 'p', 'fill');
scatter(Ldata(4), Rdata(4), pointSize, colour, 's', 'fill');
scatter(Ldata(5), Rdata(5), pointSize, colour, 'd', 'fill');
end

function averageSizes = averageSegmentSizes(cellArrayOfClasses)
    classCounts = zeros(1,5);
    frameCounts = zeros(1,5);
    for c = 1 : length(cellArrayOfClasses)
        trimmedClasses = trimFirstAndLastPhases( cellArrayOfClasses{c} );
        [ccs, fcs] = countsAndSizesOfEachClass(trimmedClasses);
        classCounts = classCounts + ccs;
        frameCounts = frameCounts + fcs;
    end
    averageSizes = frameCounts ./ classCounts;
end

function swingStance = swingStanceSizes(cellArrayOfClasses)
    allPhaseTimes = averageSegmentSizes(cellArrayOfClasses);
    swingStance(1) = allPhaseTimes(4) + allPhaseTimes(5);
    swingStance(2) = allPhaseTimes(1) + allPhaseTimes(2) + allPhaseTimes(3);
end
    
    
function [classCounts, frameCounts] = countsAndSizesOfEachClass(classes)
    classCounts = zeros(1,5);
    frameCounts = zeros(1,5);
    prevClass = -1;
    for f = 1 : length(classes)
        frameCounts( classes(f) ) = frameCounts( classes(f) ) + 1;
        if classes(f) ~= prevClass
            classCounts( classes(f) ) = classCounts( classes(f) )  + 1;
        end
        prevClass = classes(f);
    end
end

function trimmedClasses = trimFirstAndLastPhases(classes)
% Remove the first and last phases as they are probably not full length and
% could skew the average.

foundFirstPhase = false;
for Li = 1 : length(classes)-1
    if classes(Li) > 0
        foundFirstPhase = true;
    end
    if foundFirstPhase && classes(Li) ~= classes(Li+1)
        leftTrim = Li+1;
        break
    end
end

foundLastPhase = false;
for Ri = length(classes) : -1 : 2
    if classes(Ri) > 0
        foundLastPhase = true;
    end
    if foundLastPhase && classes(Ri) ~= classes(Ri-1)
        rightTrim = Ri-1;
        break
    end
end

trimmedClasses = classes(leftTrim:rightTrim);

end

function index = findIndex( dataName, titles )
for index = 1 : length(titles)
    if strcmp(titles{index}, dataName)
        return
    end
end
index = -1;
end