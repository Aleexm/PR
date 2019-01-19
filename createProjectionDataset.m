
%% Create Projection Histogram
% cleanedImages = preprocessed images
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
         projectionDataset = prdataset(pixelsSum,labels); % create prdataset
    end
end