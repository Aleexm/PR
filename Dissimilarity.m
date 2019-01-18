%% Computes and plots the error in dissimilarity space for Euclidean distances.
%scenario1 = boolean indicating which scenario is tested for
%set = dataset
%iter = number of iterations to be performed
function [e] = getEuclideanDSError(scenario1, set, iter)
    sizes = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]; % scenario 2
    if (scenario1)
        sizes = [0.01, 0.03, 0.05, 0.1, 0.15, 0.25]; % scenario 1
    end
    e = zeros(10, length(sizes), iter); % stores errors

    for it = 1:iter % for each iteration
        for s = 1:length(sizes) % for each number of representatives
            [train, test] = gendat(set, 0.9); % create training and validation sets
            repset = gendat(train, sizes(s)); % create representation set
            trainset = distm(train, repset); % compute Euclidean distances
            testset = distm(test, repset); % ""

            w = knnc(trainset, 1);
            e(1, s, it) = testc(testset, w);
            w = knnc(trainset, 3);
            e(2, s, it) = testc(testset, w);
            w = parzenc(trainset);
            e(3, s, it) = testc(testset, w);
            w = ldc(trainset);
            e(4, s, it) = testc(testset, w); % ldc
            w = fisherc(trainset);
            e(5, s, it) = testc(testset, w); %fisherc
            w = neurc(trainset);
            e(6, s, it) = testc(testset, w); %neurc
            w = qdc(trainset); 
            e(7, s, it) = testc(testset, w); % qdc
            w = loglc(trainset);
            e(8, s, it) = testc(testset, w); % loglc
            w = ldc(trainset, 0.01);
            e(9, s, it) = testc(testset, w); %ldc with regularization
            w = qdc(trainset, 0.01);
            e(10, s, it) = testc(testset, w); % qdc with regularization
        end
    end
    e = mean(e, 3)';
    plot(sizes, e);
end
%% Returns and plots the errors in dissimilarity and pseudo-Euclidean space for a
% dataset.
% iter = number of iterations to perform
% dataset = square tangent distance dataset
function [e] = getTangentPSDSError(dataset, iter)
    sizes = [2, 3, 5, 7, 10, 15, 20, 30, 40, 50];
    set = setfeatlab(dataset, getlabels(dataset));
    e = zeros(18, length(sizes), iter); % stores errors

    for it = 1:iter % for each iteration
        for s = 1:length(sizes)
            [v, sig] = psem(set, sizes(s)); % calculate embedding
            b = set * v;

            [trainset, testset, JTrain, JTest] = gendat(b, 0.5);

            d = distm(testset, trainset); 
            e(1, s, it) = testkd(d); % 1NN
            e(2, s, it) = testkd(d, 3); % 3NN
            e(3, s, it) = testpd(d); % parzen
            w = ldc(trainset);
            e(4, s, it) = testc(testset, w); % ldc
            w = fisherc(trainset);
            e(5, s, it) = testc(testset, w); %fisherc
            w = neurc(trainset);
            e(6, s, it) = testc(testset, w); %neurc
            w = qdc(trainset); 
            e(7, s, it) = testc(testset, w); % qdc
            w = loglc(trainset);
            e(8, s, it) = testc(testset, w); % loglc

            N = randperm(size(set, 1));

            b = set(:, N(1: sizes(s))); 
            trainset = b(JTrain, :); 
            testset = b(JTest, :);
            d = distm(testset, trainset); 
            e(9, s, it) = testkd(d); % 1NN
            e(10, s, it) = testkd(d, 3); % 3NN
            e(11, s, it) = testpd(d); % parzen
            w = ldc(trainset);
            e(12, s, it) = testc(testset, w); % ldc
            w = fisherc(trainset);
            e(13, s, it) = testc(testset, w); % fisherc
            w = neurc(trainset);
            e(14, s, it) = testc(testset, w); % neurc
            w = qdc(trainset); 
            e(15, s, it) = testc(testset, w); % qdc
            w = loglc(trainset);
            e(16, s, it) = testc(testset, w); % loglc
            w = ldc(trainset, 0.01);
            e(17, s, it) = testc(testset, w); % ldc with regularization
            w = qdc(trainset, 0.01);
            e(18, s, it) = testc(testset, w); % qdc with regularization
        end
 
    end
    e = mean(e, 3)';
    plot(sizes, e);
end
%% Creates a new dissimilarity matrix via a weighted average of two others
% perc1 = weight for first matrix
% perc2 = weight for second matrix
function [merge] = combineDisMeasures(perc1, perc2, mat1, mat2)
    merge = perc1 * mat1 * disnorm(mat1) + perc2 * mat2 * disnorm(mat2);
    merge = merge * disnorm(merge); % normalize final matrix also
end
%% Computes and plots the error based on dissimilarities 
%      alone via nearest neighbor classifiers 1NN and 3NN
% iter = number of iterations to be performed
% scenario1 = boolean indicating which scenario is being tested for
% dataset = square dataset
function [eKNN] = getNNError(scenario1, iter, dataset)
    sizes = [1, 3, 5, 7, 9]; % Scenario 2
    if (scenario1)
        sizes = [2, 3, 5, 7, 10, 15, 20, 30, 40, 50]; % Scneario 1
    end
    set = setfeatlab(dataset, getlabels(dataset));
    eKNN = zeros(4, length(sizes), iter); % stores errors

    for it = 1:iter % for each iteration
        for s = 1:length(sizes)

            [trainset, testset] = genddat(set, 0.5, ceil(sizes(s)/ 2)); 
            eKNN(1, s, it) = testkd(testset); % 1NN
            eKNN(2, s, it) = testkd(testset, 3); % 3NN
            [trainset,testset] = genddat(set, 0.5); 
            eKNN(3, s, it) = testkd(testset); % independent of k
            eKNN(4, s, it) = testkd(testset, 3); % independent of k
        end

    end
    eKNN = mean(eKNN, 3)';
    plot(sizes, eKNN);
end
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