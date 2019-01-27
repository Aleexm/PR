finalModels = [scalem([], 'variance') * pcam([], 0.95) * knnc([], 1), ...
	scalem([], 'variance') * pcam([], 0.8) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.95) * loglc, ...
    scalem([], 'variance') * pcam([], 0.9) * ldc([], 0.01), ...
    scalem([], 'variance') * pcam([], 0.8) * svc([], proxm('r', 1)), ...
    fisherc];

combiningMethods = {meanc, prodc, minc, maxc};

resultsHeader = ["samples_per_class", "MeanC", "ProdC", "MinC", "MaxC"]; 
cell2csv(strcat('plots_scripts/results/', 'scenario2_results_comb.csv'), resultsHeader);
for samplesPerClass=4:10
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
    cell2csv(strcat('plots_scripts/results/', 'scenario2_results_comb.csv'), string(crt_result));
end




