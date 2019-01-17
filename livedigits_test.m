imageSize = 32;

[cleanedImages, digitLabels] = generate_livedataset(imageSize);
dataset = prdataset(cleanedImages, digitLabels);