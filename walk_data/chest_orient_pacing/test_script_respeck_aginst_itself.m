% Script to train and test the classifier on separate halves of the pacing4
% data (from the respeck)

%load_chest_orient_pacing()

split = 1089;

train = pacing4(1:split, :);
test = pacing4(split+1:end, :);

train_segs = pacing4R_segs(pacing4R_segs(:, 1) <= 1150, :);

test_segs = pacing4R_segs;
test_segs(:, 1) = test_segs(:, 1) - split;
test_segs = test_segs(test_segs(:,1) > 0, :);

buildTrainTestNNAndHMM_cellArrayInputs({train}, {train_segs}, {train}, {train_segs}, test, test_segs, [40,40,40], 1, 25, 'trainscg','test',1,1,8);