function crossingsFeats = compute_crossings(inputImage)
   
    imgSize = size(inputImage, 1);
    crossingsFeats = [];
    for index=1:imgSize
        lastValue = 0;
        rowCount = 0;
        colCount = 0;
        for row=1:imgSize
            crtValue = inputImage(row, index);
            if crtValue == 1 && lastValue == 0
                rowCount = rowCount + 1;
            end
            lastValue = crtValue;
        end
        
        lastValue = 0;
        for col=1:imgSize
            crtValue = inputImage(index, col);
            if crtValue == 1 && lastValue == 0
                colCount = colCount + 1;
            end
            lastValue = crtValue;
        end
     
        crossingsFeats =[crossingsFeats, rowCount];
        crossingsFeats =[crossingsFeats, colCount];
    end  
end 
    
