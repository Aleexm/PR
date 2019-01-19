%% Get the actual dataset. Call with the values computed in computeFisherValues
% as well as the feature dataset and the top k features selected
function fisherDataset = getFisherDataset(fisherValues, featDataset, k)
    % Get index of maximum fishervalues
    [maxFisherValues,index] = maxk(fisherValues,k);
    %Subset featuredataset by selecting only top k features
    fisherDataset = seldat(featDataset,[],index,[]);
end