finalModel = [scalem([], 'variance') * pcam([], 0.9) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.9) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.95) * knnc([], 3)] * prodc;


nistDatafile = prnist([0:9], [1:1000]);
hogDataset = my_rep(nistDatafile);
hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);

trainStopIndex = round(0.8 * size(hogDataset, 1));
testStopIndex  = size(hogDataset, 1); 
trainDataset = hogDataset(1: trainStopIndex, :);
testDataset  = hogDataset((trainStopIndex + 1): testStopIndex, :);

trainedModel = trainDataset * finalModel;

testErr = testDataset * trainedModel * testc;
y_pred = testDataset * trainedModel * labeld;
y_true = testDataset.labels; 


% testErr = 0.0205
cell2csv(strcat('plots_scripts/', 'final_y_true.csv'), string(y_true));
cell2csv(strcat('plots_scripts/', 'final_y_pred.csv'), string(y_pred));






