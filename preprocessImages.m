%% Preprocesses images
% size = size the final images should have, e.g. 24, 16, 128
% toBlurr = Boolean indicating whether images should be blurred via
%           Gaussian smoothing kernels
% sigma = standard deviation to be used for isotropic Gaussian 
%         smoothing kernels
% samplesPerClass = number of images per class to use
function [cleanedImages, labels] = preprocessImages(samplesPerClass, size, toBlurr, sigma)

    cleanedImages = [];
    labels = [];

    digits = prnist([0:9], [1:samplesPerClass]); % get objects per class

    %put objects in a square box with aspect ratio 1
    %add rows/columns to make images square
    pdigits = im_box(digits, 0, 1);

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
   
            se = strel('disk',2);
            im = imclose(im, se);
            im = imerode(im,se);
            im = imdilate(im,se);
           
            im = im_resize(im, [size, size]); % Resize images to specified size
            
            if (toBlurr)
                im = imgaussfilt(im, sigma); % apply filtering
                im = imbinarize(im) % make image black-and-white again
            end
            
            cleanedImages = [cleanedImages; reshape(im, 1, [])]; % preprocessed/ cleaned images
            labels = [labels; num2str(classIndex)]; % store class labels for images
        end
        disp(classIndex); % to see progress
    end
end