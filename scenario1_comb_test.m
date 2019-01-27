finalModel = [scalem([], 'variance') * pcam([], 0.9) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.9) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.95) * knnc([], 3)];

combiningMethods = {meanc, prodc, minc, maxc};

resultsHeader = ["samples_per_class", "MeanC", "ProdC", "MinC", "MaxC"]; 
cell2csv(strcat('plots_scripts/results/', 'scenario1_results_train_comb.csv'), resultsHeader);
for crtSamples=200:25:400
    crt_result = [crtSamples];
	nistDatafile = prnist([0:9], [1:crtSamples]);
    hogDataset = my_rep(nistDatafile);
    hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);
    for methodIndex=1: size(combiningMethods, 2)
    	combiningMethod = combiningMethods(methodIndex);
        combiningMethod = combiningMethod{1};
    	untrainedModel = finalModel * combiningMethod;
        
        crt_err = prcrossval(hogDataset, untrainedModel, 5);
        crt_result = [crt_result, crt_err];
    end
    cell2csv(strcat('plots_scripts/results/', 'scenario1_results_train_comb.csv'), string(crt_result));
end