% samplesPerClass = 200; % number of training samples per class for scenario 1

% [cleanedImages, labels] = preprocess(samplesPerClass); % preprocess images
% cleanedDataset = prdataset(cleanedImages, labels); % dataset of preprocessed images with labels

%% Create your dataset for testing here
%projectionDataset = createProjectionDataset(cleanedImages, labels);
% profileDataset = createProfileDataset(cleanedImages,labels, 2);
% % I split this functionality up so you don't have to recompute all
% fisherValues when you want to select different top k features.
% allFisherValues = computeFisherValues(projectionDataset);
fisherDataset = getFisherDataset(allFisherValues,projectionDataset,153);
% fourierDataset = createFourierDataset(cleanedImages,labels);

%% Test classifiers
% Set data parameter here
data = fisherDataset;
% Test
[errorNMC, errorNMCPerClass] = prcrossval(data, nmc, 5);
[errorLDC, errorLDCPerClass] = prcrossval(data, ldc, 5);
[errorQDC, errorQDCPerClass] = prcrossval(data, qdc, 5);
[errorFISHERC, errorFISHERCPerClass] = prcrossval(data, fisherc, 5);
[errorLOGLC, errorLOGLCPerClass] = prcrossval(data, loglc, 5);
[errorKNNC1, errorKNNC1PerClass] = prcrossval(data, knnc([],1), 5);
[errorKNNC3, errorKNNC3PerClass] = prcrossval(data, knnc([],3), 5);
[errorKNNC5, errorKNNC5PerClass] = prcrossval(data, knnc([],5), 5);
[errorKNNC7, errorKNNC7PerClass] = prcrossval(data, knnc([], 7), 5);
[errorKNNC9, errorKNNC9PerClass] = prcrossval(data, knnc([],9), 5);
[errorKNNC11, errorKNNC11PerClass] = prcrossval(data, knnc([],11), 5);
[errorPARZENC, errorPARZENCPerClass] = prcrossval(data, parzenc, 5);
% Commented out because I ran out of memory. Might need to test these
% seperately
%[errorSVMLIN, errorSVMLINPerClass] = prcrossval(data, svc, 5);
%[errorSVMRBF, errorSVMRBFPerClass] = prcrossval(data, svc([],proxm('r',1)), 5);

%% Compute Fisher's Criteria Feature Values. Call with the feature dataset
%% Be sure to call getFisherDataset after to get the actual dataset
%% (Functionality split so you don't have to compute all values again for different k)
function allFisherValues = computeFisherValues(featDataset)
    numOfFeatures = size(featDataset,2); %amount of features
    numOfObjects = size(featDataset,1); %amount of objects
    allFisherValues = zeros(numOfFeatures,1); %init array
    priors = getprior(featDataset,0); %get class priors
    for featIndex = 1:numOfFeatures %For each feature do
        %Array containing feature variance according to each class
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

%% Get the actual dataset. Call with the values computed in computeFisherValues
%% as well as the feature dataset and the top k features selected
function fisherDataset = getFisherDataset(fisherValues, featDataset, k)
    % Get index of maximum fishervalues
    [maxFisherValues,index] = maxk(fisherValues,k);
    %Subset featuredataset by selecting only top k features
    fisherDataset = seldat(featDataset,[],index,[]);
end

%% Create General Fourier Descriptors (does not work correctly yet)
function fourierDataset = createFourierDataset(cleanedImages, labels)
     noOfImgs = size(cleanedImages,1); % Get number of images
     fourierDataset = zeros(noOfImgs,52);
     for imageIndex = 1:noOfImgs
         data = cleanedImages(imageIndex, :);
         image = zeros(128,128);
         for row = 1:128
             for col = 1:128
             image(row,col) = data((col-1)*128+row);  
             end
         end
         logicalImage = imbinarize(image);
         centeredImage = centerobject(logicalImage);
         fourierDataset(imageIndex, 1:52) = gfd(centeredImage,3,12);
     end
end


%% Create Projection Histogram
function projectionDataset = createProjectionDataset(cleanedImages, labels)
    noOfImgs = size(cleanedImages,1); % Get number of images
    pixelsSum = zeros(noOfImgs,256); % First 128 will be rowSums, next 128 cols.
    for imageIndex = 1:noOfImgs % loop over each image
         image = cleanedImages(imageIndex, :); % get current image
         for row = 1:128 % Loop over all its rows
             sum = 0; % Resulting sum of all pixels that are "on" in this row
             for col = 1:128 % Loop over all columns
                  % Formula for getting the right pixel. Note: In the original
                  % 16384 values, firstly row 1 to 128 for column 1 is listed,
                  % then row 1 to 128 for col 2 etc. So index at (row = 1, col = 2)
                  % is retrieved at image(129) (see formula below)
                  sum = sum + image((col-1)*128+row);  
             end                                     
             pixelsSum(imageIndex, row) = sum; % Set the sum over all cols
         end
    end

    for imageIndex = 1:noOfImgs
         image = cleanedImages(imageIndex, :);
         for col = 1:128
             sum = 0;
             for row = 1:128
                  sum = sum + image((col-1)*128+row);
             end
             pixelsSum(imageIndex, 128+col) = sum;
         end
         projectionDataset = prdataset(pixelsSum,labels);
    end
end

%% Create profiles features
% numBins must be either: 1, 2, 4, 8, 16, 32, 64, 128
function profileDataset = createProfileDataset(cleanedImages, labels, numBins)
    profiles = [];
    for imageIndex = 1:size(cleanedImages, 1) % for each image
        profilePerImage = [];
        image = cleanedImages(imageIndex, :);
        imageDim = sqrt(length(image));
        partialNum = imageDim / numBins;
        for bin = 0:(numBins - 1) % for each bin at the top of the image
            sum = 0; % sum of pixels
            for col = 1:partialNum %for each column
                i = bin * partialNum + col; % actual column index
                row = 0; % row number
                pixel = row * imageDim + i;
                while row < imageDim && image(pixel) ~= 1 % while no white pixel is encountered
                    sum = sum + 1;
                    row = row + 1;
                    pixel = row * imageDim + i;
                end
            end
            profilePerImage = [profilePerImage, sum];
        end
        for bin = 0:(numBins - 1) % for each bin at the bottom of the image
            sum = 0; % sum of pixels
            for col = 1:partialNum %for each column
                i = bin * partialNum + col; % actual column index
                row = imageDim - 1; % row number
                pixel = row * imageDim + i;
                while row >= 0 && image(pixel) ~= 1  %while no white pixel is encountered
                    sum = sum + 1;
                    row = row - 1;
                    pixel = row * imageDim + i;
                end
            end
            profilePerImage = [profilePerImage, sum];
        end
        for bin = 0: (numBins - 1) % for each bin at the left of the image
            sum = 0; % sum of pixels
            for row = 1:partialNum %for each row
                i = bin * partialNum + row; % actual row index
                col = 1; % column number
                pixel = (i - 1) * imageDim + col;
                while col <= imageDim && image(pixel) ~= 1  %while no white pixel is encountered
                    sum = sum + 1;
                    col = col + 1;
                    pixel = (i - 1) * imageDim + col;
                end
            end
            profilePerImage = [profilePerImage, sum];
        end
        for bin = 0: (numBins - 1) % for each bin at the right of the image
            sum = 0; % sum of pixels
            for row = 1:partialNum %for each row
                i = bin * partialNum + row; % actual row index
                col = imageDim; % column number
                pixel = (i - 1) * imageDim + col;
                while col >= 1 && image(pixel) ~= 1  %while no white pixel is encountered
                    sum = sum + 1;
                    col = col - 1;
                    pixel = (i - 1) * imageDim + col;
                end
            end
            profilePerImage = [profilePerImage, sum];
        end
        profiles = [profiles; profilePerImage];
    end

    profileDataset = prdataset(profiles, labels); % create dataset with new features
end

function [cleanedImages, labels] = preprocess(samplesPerClass)

    prdatafiles;
    cleanedImages = [];
    labels = [];

    digits = prnist([0:9], [1:samplesPerClass]); % get objects per class

    %put objects in a square box with aspect ratio 1
    %add rows/columns to make images square
    pdigits = im_box(digits, 0, 1);

    %rotate images to same orientation
    %%obj2 = im_rotate(obj1)

    %resize images to 128 x 128 pixels
    pdigits = im_resize(pdigits, [128, 128]);

    %create empty box around objects
    %add rows/columns and keep image square
    pdigits = im_box(pdigits, 1, 0);

    % Clean/ preprocess each image
    for classIndex = 0:9 % for each class
        for imageIndex = 1:samplesPerClass % for each image in the class
            i = classIndex * samplesPerClass + imageIndex; % get overall index of image
            im = data2im(pdigits(i));
   
            %commented in order to don't generate 250x2 images
            %imwrite(im, sprintf('imgs/%s_%d.jpg',"orig",i));
            se = strel('disk',2);
            im = imclose(im, se);
            im = imerode(im,se);
            im = imdilate(im,se);
            % resized images to maintain 128x128
            im = im_resize(im, [128,128]);
            %commented same reasoning as above
            %imwrite(im, sprintf('imgs/%s_%d.jpg',"proc",i));
            cleanedImages = [cleanedImages; reshape(im, 1, [])]; % preprocessed/ cleaned images
            labels = [labels; num2str(classIndex)]; % store class labels for images
        end
        disp(classIndex); % to see progress
    end
end