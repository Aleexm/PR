% Returns a dataset with the profile features
% numBins must be either: 1, 2, 4, 8, 16, 32, 64, 128
function profileDataset = getProfileDataset(cleanedImages, labels, numBins)
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
                while row < imageDim && image(pixel) ~= 1 %while no white pixel is encountered
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