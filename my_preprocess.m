function [cleanedImages, digitLabels] = my_preprocess(nistDatafile, imageSize)

    samplesPerClass = size(nistDatafile, 1) / 10;  

    cleanedImages = [];
    digitLabels = {{}};
    
    for classIndex = 0:9
        for imageIndex = 1:samplesPerClass
            im = data2im(nistDatafile(classIndex * samplesPerClass + imageIndex));
            se = strel('disk',1);
            im = imclose(im, se);
            im = imerode(im,se);
            im = imdilate(im,se);

            im = im_box(im, 0, 1);
            im = im_resize(im, [imageSize - 2,imageSize - 2]);
            im = im_box(im, 1, 0);
            
            cleanedImages = [cleanedImages; reshape(im, 1, [])]; 
            digitLabels = [digitLabels; num2str(classIndex)]; 
        end
        disp(classIndex);
    end
end