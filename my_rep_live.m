function liveDataset = my_rep_live(imageSize)

	[cleanedImages, digitLabels] = generate_livedataset(imageSize);
	hogFeats = [];
	for imageIndex = 1:size(cleanedImages, 1)
    	crtImg = reshape(cleanedImages(imageIndex, :), [imageSize, imageSize]);
    	[crtFeats, ~] = extractHOGFeatures(crtImg, 'CellSize',[6 6]);
    	hogFeats = [hogFeats; crtFeats];
	end

	liveDataset = prdataset(double(hogFeats), digitLabels);
end