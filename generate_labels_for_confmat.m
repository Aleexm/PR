samplesPerClass = 500;

nistDatafile = prnist([0:9], [1:samplesPerClass]);
hogDataset = my_rep(nistDatafile);
hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);

trainStopIndex = round(0.7 * size(hogDataset, 1));
testStopIndex  = size(hogDataset, 1); 
trainDataset = hogDataset(1: trainStopIndex, :);
testDataset  = hogDataset((trainStopIndex + 1): testStopIndex, :);

untrainedModel = scalem([], 'variance') * pcam([], 0.9) * parzenc;
trainedModel = trainDataset * untrainedModel;

y_pred = testDataset * trainedModel * labeld;
y_true = testDataset.labels; 

cell2csv(strcat('plots_scripts/', 'y_true.csv'), string(y_true));
cell2csv(strcat('plots_scripts/', 'y_pred.csv'), string(y_pred));

