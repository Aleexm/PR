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