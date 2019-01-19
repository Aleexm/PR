%% Create General Fourier Descriptors (does not work correctly yet)
function fourierDataset = createFourierDataset(cleanedImages, labels)
     noOfImgs = size(cleanedImages,1); % Get number of images
     fourierDataset = zeros(noOfImgs,52);
     for imageIndex = 1:noOfImgs
         data = cleanedImages(imageIndex, :);
         image = zeros(128,128);
         for row = 1:128 % for each row
             for col = 1:128 % for each column
             image(row,col) = data((col-1)*128+row);  
             end
         end
         
         logicalImage = imbinarize(image);
         centeredImage = centerobject(logicalImage);
         fourierDataset(imageIndex, 1:52) = gfd(centeredImage,3,12);
     end
end