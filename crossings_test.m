samplesPerClass = 10;
imageSize = 32;
kfolds = 10;

[cleanedImages, digitLabels] = preprocess(samplesPerClass, imageSize);

crossFeats = [];
for imageIndex = 1:size(cleanedImages, 1)
    crtImg = reshape(cleanedImages(imageIndex, :), [imageSize, imageSize]);
    crtFeats = compute_crossings(crtImg);
    crossFeats = [crossFeats; crtFeats];
end

crossDataset = prdataset(double(crossFeats), digitLabels);

models = {nmc, ldc, qdc, fisherc, loglc, parzenc, knnc([], 1), knnc([], 3), ...
          knnc([], 5), knnc([], 7), knnc([], 9), knnc([], 11), ...
          svc([], proxm('p',1)), svc([], proxm('r', 1)), neurc};

names = ["nmc", "ldc", "qdc", "fisherc", "loglc", "parzenc", "knn_1", ...
         "knn_3", "knn_5", "knn_7", "knn_9", "knn_11", "svm_lin", ...
         "svm_rbf", "neurc"];
     
featExtractFuncs = {pcam([], 0.0), pcam([], 0.6), pcam([], 0.7), ...
                    pcam([], 0.8), pcam([], 0.9), pcam([], 0.95)};
featExtractNames = ["without", "pcam_6", "pcam_7", "pcam_8", "pcam_9", "pcam_95"];  
           
for featExtractIndex = 1:size(featExtractFuncs, 2)
    if featExtractIndex == 1
        mapping = 1;
    else
        mapping = featExtractFuncs{featExtractIndex};
    end
    
    for modelIndex = 1: size(models, 2)
        crt_model = models{modelIndex};
    
        tic;
        [error, errorPerClass] = prcrossval(crossDataset, mapping * crt_model, kfolds);
        deltaT = toc;
        disp(errorPerClass);
    
        crt_result = [names(modelIndex), error, deltaT];
        
        cell2csv(sprintf('results/cross_%dx%d_%s_%d-percls.csv',imageSize, imageSize, ...
            featExtractNames(featExtractIndex), samplesPerClass), crt_result);
    end
end