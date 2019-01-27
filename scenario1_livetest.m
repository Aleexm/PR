imageSize = 32;
samplesPerClass = 400;

liveDataset = my_rep_live(imageSize);

nistDatafile = prnist([0:9], [1:samplesPerClass]);
hogDataset = my_rep(nistDatafile);
hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);

finalModel = [scalem([], 'variance') * pcam([], 0.9) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.9) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.95) * knnc([], 3)] * prodc;

trainedModel = hogDataset * finalModel;

y_pred = liveDataset * trainedModel * labeld;
y_true = liveDataset.labels; 

cell2csv(strcat('plots_scripts/results/', 's1_y_true_live.csv'), string(y_true));
cell2csv(strcat('plots_scripts/results/', 's1_y_pred_live.csv'), string(y_pred));