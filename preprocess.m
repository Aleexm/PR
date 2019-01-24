function [cleanedImages, digitLabels] = preprocess(samplesPerClass, imageSize)

    cleanedImages = [];
    digitLabels = [];
    
    original_digits = prnist([0:9], [1:samplesPerClass]);
    
    for classIndex = 0:9
        randomIndex = randi([1 samplesPerClass]);
        for imageIndex = 1:samplesPerClass 
            i = classIndex * samplesPerClass + imageIndex; 
            im = data2im(original_digits(i));
            
            %{
            if imageIndex == randomIndex
                imwrite(im, sprintf('output\\%s_%d.jpg',"orig",classIndex));
            end
            %}
        
            se = strel('disk',1);
            im = imclose(im, se);
            im = imerode(im,se);
            im = imdilate(im,se);
         
            im = im_box(im, 0, 1);
            im = im_resize(im, [imageSize - 2,imageSize - 2]);
            im = im_box(im, 1, 0);
            
            %{
            if imageIndex == randomIndex
                imwrite(im, sprintf('output\\%s_%d.jpg',"proc",classIndex));
            end
            %}
                
            cleanedImages = [cleanedImages; reshape(im, 1, [])]; 
            digitLabels = [digitLabels; num2str(classIndex)]; 
        end
        disp(classIndex);
    end
end
    
    
    
    
    