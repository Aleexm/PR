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
		crt_filename = ("digit" if i % 2 == 0 else "pdigit") + str(i // 2) + ".jpg"
		crt_filename = os.path.join("selected", crt_filename)
		print(crt_filename)
		# cv2.IMREAD_GRAYSCALE
		img = cv2.imread(crt_filename)
		fig.add_subplot(rows, columns, i + 1)
		plt.axis('off')
		plt.title("Before" if i % 2 == 0 else "After", fontsize=12)
		plt.imshow(img, cmap = 'gray')
	
	plt.savefig("livetest_before_after_preproc.jpg")
	plt.close()