final_models = {knnc([], 1), scalem([], 'variance') * pcam([], 0.95) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.9) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.8) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.7) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.6) * knnc([], 1)};

resultsHeader = ["samples_per_class", "1NN", "95PCA_1NN", "90PCA_1NN", ...
    "80PCA_1NN", "70PCA_1NN", "60PCA_1NN"]; 
cell2csv(strcat('plots_scripts/results/', 'scenario2_results.csv'), resultsHeader);
for samplesPerClass=4:10
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
    cell2csv(strcat('plots_scripts/results/', 'scenario2_results.csv'), string(crt_result));
end
