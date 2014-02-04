% Segments from each sensor individually
for i = 12 : -3 : 1
    [classes, error] = buildTrainTestNNAndHMM(gl4east1_L(:,i-2:i), gl4east1_L_segs, gl4east1_L(:,i-2:i), gl4east1_L_segs, gl4west1_L(:,i-2:i), gl4west1_L_segs, [10,10,10], 1, 13, 'trainscg');
    
    if i==12
        createfigure(gl4west1_L(:,i-2:i), classes, 3, '3-Axis Gyroscope Walk Data: Left foot', num2str(error,2));
    elseif i==9
        createfigure(gl4west1_L(:,i-2:i), classes, 3, '3-Axis Gyroscope Walk Data: Left shin', num2str(error,2));
    elseif i==6
        createfigure(gl4west1_L(:,i-2:i), classes, 3, '3-Axis Gyroscope Walk Data: Left thigh', num2str(error,2));
    elseif i==3
        createfigure(gl4west1_L(:,i-2:i), classes, 3, '3-Axis Gyroscope Walk Data: Pelvis', num2str(error,2));
    end
end

% Segments from all sensors
[classes, error] = buildTrainTestNNAndHMM(gl4east1_L, gl4east1_L_segs, gl4east1_L, gl4east1_L_segs, gl4west1_L, gl4west1_L_segs, [10,10,10], 1, 13, 'trainscg');
createfigure(gl4west1_L, classes, 9, '3-Axis Gyroscope Walk Data: Left Leg And Pelvis (Four sensors)', num2str(error,2));

% True segments
[~,targets] = formatForNetwork(gl4west1_L, gl4west1_L_segs, 1, 13);
classes = realignNetworkOutput(targets, 1, 13, length(gl4west1_L));
createfigure(gl4west1_L, classes, 9, '3-Axis Gyroscope Walk Data: Left Leg And Pelvis (Four sensors)', num2str(0,2));

