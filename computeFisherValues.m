%% (Functionality split so you don't have to compute all values again for different k)
function allFisherValues = computeFisherValues(featDataset)

    numOfFeatures = size(featDataset,2); % amount of features
    numOfObjects = size(featDataset,1); % amount of objects
    allFisherValues = zeros(numOfFeatures,1); % init array
    priors = getprior(featDataset,0); % get class priors
    
    for featIndex = 1:numOfFeatures % For each feature do
        % Array containing feature variance according to each class
        currentFeatureVariancePerClass = zeros(10,1); 
        % I'm sorry
        class1feats = [];
        class2feats = [];
        class3feats = [];
        class4feats = [];
        class5feats = [];
        class6feats = [];
        class7feats = [];
        class8feats = [];
        class9feats = [];
        class10feats = [];
        for objectIndex = 1:numOfObjects % Loop over all objects for this feat
            label = featDataset.nlab(objectIndex); %get label
            if label == 1
                class1feats = [class1feats,featDataset.data(objectIndex,featIndex)];
            elseif label == 2
                class2feats = [class2feats,featDataset.data(objectIndex,featIndex)];
            elseif label == 3
                class3feats = [class3feats,featDataset.data(objectIndex,featIndex)];
            elseif label == 4
                class4feats = [class4feats,featDataset.data(objectIndex,featIndex)];
            elseif label == 5
                class5feats = [class5feats,featDataset.data(objectIndex,featIndex)];
            elseif label == 6
                class6feats = [class6feats,featDataset.data(objectIndex,featIndex)];                
            elseif label == 7
                class7feats = [class7feats,featDataset.data(objectIndex,featIndex)];
            elseif label == 8
                class8feats = [class8feats,featDataset.data(objectIndex,featIndex)];
            elseif label == 9
                class9feats = [class9feats,featDataset.data(objectIndex,featIndex)];
            else
                class10feats = [class10feats,featDataset.data(objectIndex,featIndex)];
            end
        end
        currentFeatureVariancePerClass(1) = var(class1feats);
        currentFeatureVariancePerClass(2) = var(class2feats);
        currentFeatureVariancePerClass(3) = var(class3feats);
        currentFeatureVariancePerClass(4) = var(class4feats);
        currentFeatureVariancePerClass(5) = var(class5feats);
        currentFeatureVariancePerClass(6) = var(class6feats);
        currentFeatureVariancePerClass(7) = var(class7feats);
        currentFeatureVariancePerClass(8) = var(class8feats);
        currentFeatureVariancePerClass(9) = var(class9feats);
        currentFeatureVariancePerClass(10) = var(class10feats);
        
        %compute Fisher's value for this feature
        sum = 0;
        for classIndex = 1:10
            sum = sum + priors(classIndex) * ...
                currentFeatureVariancePerClass(classIndex);
        end
        allFisherValues(featIndex) = 1/sum;
    end
end
