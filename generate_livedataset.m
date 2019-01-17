function [cleanedImages, digitLabels] = generate_livedataset(imageSize)

    cleanedImages = [];
    digitLabels = [];
    for digit=0:9
        for index=1:10
            crt_img = imread(sprintf('livetest_data\\digit%d-%d.jpg',digit, index));
            crt_img = crt_img(2:size(crt_img, 1) - 1, 3: size(crt_img, 2) - 2);
            crt_img = imcomplement(im2bw(crt_img));
            crt_img = double(crt_img);
        
            se = strel('disk',1);
            crt_img = imclose(crt_img,se);
            crt_img = imerode(crt_img,se);
            crt_img = imdilate(crt_img,se);
        
            crt_img = im_box(crt_img, 0, 1);
            crt_img = im_resize(crt_img, [imageSize - 2,imageSize - 2]);
            crt_img = im_box(crt_img, 1, 0);
            
            imwrite(crt_img, sprintf('livetest_data\\pdigit%d-%d.jpg',digit, index));
            
        cleanedImages = [cleanedImages; reshape(crt_img, 1, [])]; 
        digitLabels = [digitLabels; num2str(digit)]; 
        end
    end
end
            
            
        
        
        