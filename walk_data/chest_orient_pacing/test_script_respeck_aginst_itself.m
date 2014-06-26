% Script to train and test the classifier on separate halves of the pacing4
% data (from the respeck)

%load_chest_orient_pacing()

data = respeckPacingSometimes1;
segs = respeckPacingSometimes1R_segs;

split = ceil(length(data)/2);

train = data(1:split, :);
test = data(split+1:end, :);

train_segs = segs(segs(:, 1) <= split, :);

test_segs = segs;
test_segs(:, 1) = test_segs(:, 1) - split;
test_segs = test_segs(test_segs(:,1) > 0, :);

buildTrainTestNNAndHMM_cellArrayInputs({train}, {train_segs}, {train}, {train_segs}, test, test_segs, [40,40,40], 1, 25, 'trainscg','RESpeck gait',1,0,8);