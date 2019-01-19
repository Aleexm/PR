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