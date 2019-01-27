samplesPerClass = 1000;

nistDatafile = prnist([0:9], [1:samplesPerClass]);
hogDataset = my_rep(nistDatafile);

randIndexes = randperm(samplesPerClass);
trainIndexes = [];
for i=1:800
    for digit=0:9
        trainIndexes = [trainIndexes, randIndexes(i) + samplesPerClass * digit];
    end
end

testIndexes = setdiff([1: size(hogDataset, 1)], trainIndexes);

trainDataset = hogDataset(trainIndexes, :);
testDataset = hogDataset(testIndexes, :);

finalModel = [scalem([], 'variance') * pcam([], 0.9) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.9) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.95) * knnc([], 3)] * prodc;

%{
finalModel = [scalem([], 'variance') * pcam([], 0.95) * knnc([], 1), ...
	scalem([], 'variance') * pcam([], 0.8) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.95) * loglc, ...
    scalem([], 'variance') * pcam([], 0.9) * ldc([], 0.01), ...
    scalem([], 'variance') * pcam([], 0.8) * svc([], proxm('r', 1)), ...
    fisherc] * prodc;
%}

trainedModel = trainDataset * finalModel;

y_pred = testDataset * trainedModel * labeld;
y_true = testDataset.labels; 

cell2csv(strcat('plots_scripts/results/', 's1_y_true_all.csv'), string(y_true));
cell2csv(strcat('plots_scripts/results/', 's1_y_pred_all.csv'), string(y_pred));