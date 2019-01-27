imageSize = 32;
samplesPerClass = 10;

liveDataset = my_rep_live(imageSize);

nistDatafile = prnist([0:9], [1:samplesPerClass]);
hogDataset = my_rep(nistDatafile);
hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);

finalModel = [scalem([], 'variance') * pcam([], 0.95) * knnc([], 1), ...
	scalem([], 'variance') * pcam([], 0.8) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.95) * loglc, ...
    scalem([], 'variance') * pcam([], 0.9) * ldc([], 0.01), ...
    scalem([], 'variance') * pcam([], 0.8) * svc([], proxm('r', 1)), ...
    fisherc] * prodc;

trainedModel = hogDataset * finalModel;

y_pred = liveDataset * trainedModel * labeld;
y_true = liveDataset.labels; 

cell2csv(strcat('plots_scripts/results/', 's2_y_true_live.csv'), string(y_true));
cell2csv(strcat('plots_scripts/results/', 's2_y_pred_live.csv'), string(y_pred));