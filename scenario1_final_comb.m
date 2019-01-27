finalModels = [scalem([], 'variance') * pcam([], 0.9) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.9) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.95) * knnc([], 3)];

combiningMethods = {meanc, prodc, minc, maxc};

resultsHeader = ["samples_per_class", "MeanC", "ProdC", "MinC", "MaxC"]; 
cell2csv(strcat('plots_scripts/results/', 'scenario1_results_comb.csv'), resultsHeader);
for samplesPerClass=200:25:400
	nistDatafile = prnist([0:9], [1:samplesPerClass]);
    hogDataset = my_rep(nistDatafile);
    hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);
    crt_result = [samplesPerClass];
    for methodIndex=1: size(combiningMethods, 2)
    	combiningMethod = combiningMethods(methodIndex);
    	combiningMethod = combiningMethod{1};
    	untrainedModel = finalModels * combiningMethod;
    	trainedModel = hogDataset * untrainedModel;
        
    	crt_err = nist_eval('my_rep', trainedModel, 100);
        crt_result = [crt_result, crt_err];
    end
    cell2csv(strcat('plots_scripts/results/', 'scenario1_results_comb.csv'), string(crt_result));
end