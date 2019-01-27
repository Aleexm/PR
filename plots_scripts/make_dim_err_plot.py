import matplotlib
matplotlib.use("TkAgg")

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import os

def make_dim_err_plot(results_filename, target_err, plt_filename,  plt_title):

	df = pd.read_csv(results_filename)
	df.sort_values(by=['dim'], inplace = True)

	classifiers = df.columns[1:].values
	dims  = df['dim'].values
	target_list = [target_err for _ in range(len(dims))]

	x = np.array(range(len(dims)))
	plt_xticks = [str(elem) for elem in dims]
	assert x.shape[0] == len(plt_xticks)

	sns.set()
	fig = plt.figure(figsize=(10, 10))
	ax  = plt.subplot(111)

	colors = ['orange', 'blue', 'red', 'yellow', 'navy', 'maroon', 'violet']
	min_err = 1.0
	max_err = 0.0
	for i, classifier_name in enumerate(classifiers):
		crt_y = df[classifier_name]
		plt.plot(x, crt_y, linestyle='None', marker='o', color = colors[i])
		min_err = min(min_err, min(crt_y))
		max_err = max(max_err, max(crt_y))


	plt.plot(x, target_list, linestyle='-', color = 'black')

	plt.xticks(x, plt_xticks)
	if target_err == 0.05:
		plt.yticks([0.0 + i * 0.1 for i in range(10)])
	
	ax.set_xlabel('Average number of dimensions')
	ax.set_ylabel('Classification error')
	plt.title(plt_title)

	box = ax.get_position()
	ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
	plt.legend(classifiers, loc='center left', bbox_to_anchor=(1, 0.5),
		fancybox=True, shadow=True)

	plt.savefig(plt_filename)
	plt.close()



if __name__ == "__main__":

	make_dim_err_plot(os.path.join("results", "10fold_err_pixels_pca_128_scenario2.csv"),
		0.25, os.path.join("output", "10fold_err_pixels_pca_128_scenario2.jpg"), 
		"LOO Error for PCA for the pixel representation based on 128x128 images")
	make_dim_err_plot(os.path.join("results", "10fold_err_pixels_pca_32_scenario2.csv"),
		0.25, os.path.join("output", "10fold_err_pixels_pca_32_scenario2.jpg"), 
		"LOO Error for PCA for the pixel representation based on 32x32 images")
	make_dim_err_plot(os.path.join("results", "5fold_err_pixels_pca_128_scenario1.csv"),
		0.05, os.path.join("output", "5fold_err_pixels_pca_128_scenario1.jpg"), 
		"5-fold cross validation error for PCA for the pixel representation based on 128x128 images")
	make_dim_err_plot(os.path.join("results", "5fold_err_pixels_pca_32_scenario1.csv"),
		0.05, os.path.join("output", "5fold_err_pixels_pca_32_scenario1.jpg"), 
		"5-fold cross validation error for PCA for the pixel representation based on 32x32 images")