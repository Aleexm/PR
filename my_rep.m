function hogDataset = my_rep(nistDatafile)

    samplesPerClass = size(nistDatafile, 1) / 10;
    hogFeats = [];
    digitLabels = [];
    
    for classIndex = 0:9
        for imageIndex = 1:samplesPerClass
            i = classIndex * samplesPerClass + imageIndex;
            im = data2im(nistDatafile(i));
            
            se = strel('disk',1);
            im = imclose(im, se);
            im = imerode(im,se);
            im = imdilate(im,se);

            im = im_box(im, 0, 1);
            im = im_resize(im, [32 - 2,32 - 2]);
            im = im_box(im, 1, 0);
            
            [crtFeats, ~] = extractHOGFeatures(im, 'CellSize',[6 6]);
            hogFeats = [hogFeats; crtFeats];
            digitLabels = [digitLabels; strcat('digit_', num2str(classIndex))];
        end
        disp(classIndex);
    end
    
    hogDataset = prdataset(double(hogFeats), digitLabels);
            
end