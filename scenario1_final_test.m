final_models = {scalem([], 'variance') * pcam([], 0.95) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.9) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.8) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.7) * parzenc, ...
    scalem([], 'variance') * pcam([], 0.6) * parzenc};

resultsHeader = ["samples_per_class", "95PCA_PARZEN", "90PCA_PARZEN", ...
    "80PCA_PARZEN", "70PCA_PARZEN", "60PCA_PARZEN"]; 
cell2csv('scenario1_results.csv', resultsHeader);
for samplesPerClass=200:25:400
    nistDatafile = prnist([0:9], [1:samplesPerClass]);
    hogDataset = my_rep(nistDatafile);
    hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);
    crt_result = [samplesPerClass];
    for modelIndex = 1: size(final_models, 2)
        untrainedModel = final_models(modelIndex);
        untrainedModel = untrainedModel{1};
        trainedModel = hogDataset * untrainedModel;
        
        crt_err = nist_eval('my_rep', trainedModel, 100);
        crt_result = [crt_result, crt_err];
    end
    cell2csv('scenario1_results.csv', string(crt_result));
end
