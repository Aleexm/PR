%% Computes and plots the error based on dissimilarities 
%      alone via nearest neighbor classifiers 1NN and 3NN
% iter = number of iterations to be performed
% scenario1 = boolean indicating which scenario is being tested for
% dataset = square dataset
function [eKNN] = getDissimilarityNNError(scenario1, iter, dataset)
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