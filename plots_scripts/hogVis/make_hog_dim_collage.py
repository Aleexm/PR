import matplotlib
matplotlib.use("TkAgg")

import matplotlib.pyplot as plt
from matplotlib import rcParams
import pandas as pd
import os
import cv2

if __name__ == "__main__":
	
	rcParams['axes.titlepad'] = 0.5
	fig = plt.figure(figsize = (12, 10))

	imgs_filenames = ["hog2x2_8100", "hog4x4_1764", "hog6x6_576", "hog8x8_324"]
	subtitles = ["HOG with " + c_size + " cellsize - " + f_size + " features" for
				 c_size, f_size in zip(["2x2", "4x4", "6x6", "8x8"], 
				 ["8100", "1764", "576", "324"])]
	rows, columns = 2, 2
	for i in range(0, columns*rows):
		crt_filename = imgs_filenames[i] + ".jpg"
		crt_filename = os.path.join("hog_vis_to_plot", crt_filename)
		img = cv2.imread(crt_filename, cv2.IMREAD_GRAYSCALE)
		fig.add_subplot(rows, columns, i + 1)
		plt.axis('off')
		plt.title(subtitles[i], fontsize=14)
		plt.imshow(img, cmap = 'gray')
	
	plt.savefig("hog_celldim_featsz.jpg")
	plt.close()