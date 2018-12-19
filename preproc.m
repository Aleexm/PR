samplesPerClass = 200; % number of training samples per class for scenario 1

[cleanedImages, labels] = preprocess(samplesPerClass); % preprocess images
cleanedDataset = prdataset(cleanedImages, labels); % dataset of preprocessed images with labels

%% Create profiles features

profiles = [];

for imageIndex = 1:size(cleanedImages, 1) % for each image
    profilePerImage = [];
    image = cleanedImages(imageIndex, :);
    imageDim = sqrt(length(image));
    for bin = 0:9 % for each bin at the top of the image
        sum = 0; % sum of pixels
        for col = 1:13 %for each column
            i = bin * 13 + col; % actual column index
            row = 0; % row number
            pixel = row * imageDim + i;
            while row < imageDim && image(pixel) ~= 1 %while no white pixel is encountered
                sum = sum + 1;
                row = row + 1;
                pixel = row * imageDim + i;
            end
        end
        profilePerImage = [profilePerImage, sum];
    end
    for bin = 0:9 % for each bin at the bottom of the image
        sum = 0; % sum of pixels
        for col = 1:13 %for each column
            i = bin * 13 + col; % actual column index
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
    for bin = 0:9 % for each bin at the left of the image
        sum = 0; % sum of pixels
        for row = 1:13 %for each row
            i = bin * 13 + row; % actual row index
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
    for bin = 0:9 % for each bin at the right of the image
        sum = 0; % sum of pixels
        for row = 1:13 %for each row
            i = bin * 13 + row; % actual row index
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

%% Test classifiers

% use prcrossval(pdigits,[], 10) to perform 10-fold-cross validation to estimate test error

[error, errorPerClass] = prcrossval(profileDataset, nmc, 5);

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
            %commented same reasoning as above
            %imwrite(im, sprintf('imgs/%s_%d.jpg',"proc",i));
            cleanedImages = [cleanedImages; reshape(im, 1, [])]; % preprocessed/ cleaned images
            labels = [labels; num2str(classIndex)]; % store class labels for images
        end
        disp(classIndex); % to see progress
    end
end