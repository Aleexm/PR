%% Creates matrix needed for tangent dissimilarity matrix creation
%set = dataset
%dim = image dimensionality (e.g. 32, 128)
%numIm = number of images in dataset
function [dataS] = compTangentMatrix(set, dim, numIm)
    dataS = [];
    for i = 1:numIm
        a = set(i, :);
        aColumn = reshape(a.data, dim * dim, 1);
        dataS = [dataS, aColumn];
    end
end