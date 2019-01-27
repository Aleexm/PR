import pandas as pd
import matplotlib
matplotlib.use("TkAgg")
import matplotlib.pyplot as plt
from matplotlib import rcParams
import seaborn as sns
import numpy as np
import os
import cv2

if __name__ == "__main__":
	
	rcParams['axes.titlepad'] = 0.5
	fig = plt.figure(figsize = (4, 5))

	rows, columns = 5, 4
	for i in range(0, columns*rows):
		crt_filename = ("pdigit" if i % 2 == 0 else "proc_") + str(i // 2) + ".jpg"
		folder = "livetest_data" if i % 2 == 0 else "preprocess_output"
		crt_filename = os.path.join(folder, "selected", crt_filename)
		img = cv2.imread(crt_filename, cv2.IMREAD_GRAYSCALE)
		fig.add_subplot(rows, columns, i + 1)
		plt.axis('off')
		plt.title("Our" if i % 2 == 0 else "Nist", fontsize=12)
		plt.imshow(img, cmap = 'gray')
	
	plt.savefig("our_vs_nist.jpg")
	plt.close()