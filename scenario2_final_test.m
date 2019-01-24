final_models = {knnc([], 1), scalem([], 'variance') * pcam([], 0.95) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.9) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.8) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.7) * knnc([], 1), ...
    scalem([], 'variance') * pcam([], 0.6) * knnc([], 1)};

resultsHeader = ["samples_per_class", "1NN", "95PCA_1NN", "90PCA_1NN", ...
    "80PCA_1NN", "70PCA_1NN", "60PCA_1NN"]; 
cell2csv('scenario2_results.csv', resultsHeader);
for samplesPerClass=4:10
    nistDatafile = prnist([0:9], [1:samplesPerClass]);
    hogDataset = my_rep(nistDatafile);
    crt_result = [samplesPerClass];
    for modelIndex = 1: size(final_models, 2)
        untrainedModel = final_models(modelIndex);
        untrainedModel = untrainedModel{1};
        trainedModel = hogDataset * untrainedModel;
        
        crt_err = nist_eval('my_rep', trainedModel, 100);
        crt_result = [crt_result, crt_err];
    end
    cell2csv('scenario2_results.csv', string(crt_result));
end

        
        






%{
[cleanedImages, digitLabels] = preprocess(samplesPerClass, imageSize);

hogFeats = [];
for imageIndex = 1:size(cleanedImages, 1)
    crtImg = reshape(cleanedImages(imageIndex, :), [imageSize, imageSize]);
    [crtFeats, crtHogVis] = extractHOGFeatures(crtImg, 'CellSize',[6 6]);
    hogFeats = [hogFeats; crtFeats];
end

hogDataset = prdataset(double(hogFeats), digitLabels);

w = scalem([], 'variance') * pcam([], 0.95) * parzenc
wn = hogDataset * w

[a, b] = prcrossval(hogDataset, w, 5)

e = nist_eval('my_rep', w, 100)


---------
samplesPerClass = 100;
imageSize = 32;

nist_datafile = prnist([0:9], [1:samplesPerClass]);
hogDataset = my_rep(nist_datafile);
hogDataset = hogDataset(randperm(size(hogDataset, 1)), :);

w = scalem([], 'variance') * pcam([], 0.9) * parzenc;
wn = hogDataset * w;

nist_eval('my_rep', wn, 10)
-----------
%}

%{
    N = size(hogDataset,1)  % total number of rows 
tf = false(N,1)    % create logical index vector
tf(1:round(0.9*N)) = true     
tf = tf(randperm(N))   % randomise order
dataTraining = hogDataset(tf,:) 
dataTesting = hogDataset(~tf,:)
Undefined function or variable 'hogDatase'.
 %}
