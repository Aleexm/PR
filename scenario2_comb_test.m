finalModel = [scalem([], 'variance') * pcam([], 0.95) * knnc([], 1), ...
	scalem([], 'variance') * pcam([], 0.8) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.95) * loglc, ...
    scalem([], 'variance') * pcam([], 0.9) * ldc([], 0.01), ...
    scalem([], 'variance') * pcam([], 0.8) * svc([], proxm('r', 1)), ...
    fisherc];

combiningMethods = {meanc, prodc, minc, maxc};

resultsHeader = ["samples_per_class", "MeanC", "ProdC", "MinC", "MaxC"]; 
cell2csv(strcat('plots_scripts/results/', 'scenario2_results_train_comb.csv'), resultsHeader);
for crtSamples=4:10
    crt_result = [crtSamples];
	nistDatafile = prnist([0:9], [1:crtSamples]);
    hogDataset = my_rep(nistDatafile);
    hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);
    for methodIndex=1: size(combiningMethods, 2)
    	combiningMethod = combiningMethods(methodIndex);
        combiningMethod = combiningMethod{1}
    	untrainedModel = finalModel * combiningMethod;

        crt_err = prcrossval(hogDataset, untrainedModel, 10);
        crt_result = [crt_result, crt_err];
    end
    cell2csv(strcat('plots_scripts/results/', 'scenario2_results_train_comb.csv'), string(crt_result));
end