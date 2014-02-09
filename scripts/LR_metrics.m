loadGyroAndSevenOrientData

L = buildTrainTestNNAndHMM(gl4east1_L, gl4east1_L_segs, gl4east1_L, gl4east1_L_segs, gl4west1_L, gl4west1_L_segs, [10,10,10], 1, 13, 'trainscg');
R = buildTrainTestNNAndHMM(gl4east1_R, gl4east1_R_segs, gl4east1_R, gl4east1_R_segs, gl4west1_R, gl4west1_R_segs, [10,10,10], 1, 13, 'trainscg');

L_CCs = findCompleteCycles(L, 6);
R_CCs = findCompleteCycles(R, 6);

cycleMetrics(L_CCs, R_CCs, 51.4, gl4west1_L, gl4west1_R)