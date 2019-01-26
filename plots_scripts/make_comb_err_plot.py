import matplotlib
matplotlib.use("TkAgg")

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import os

def make_comb_err_plot(results_filename, plt_filename,  plt_title):

	df = pd.read_csv(results_filename)
	df.sort_values(by=['samples_per_class'], inplace = True)

	comb_methods = df.columns[1:].values
	dims  = df['samples_per_class'].values

	x = np.array(range(len(dims)))
	plt_xticks = [str(elem) for elem in dims]
	assert x.shape[0] == len(plt_xticks)

	sns.set()
	fig = plt.figure(figsize=(10, 10))
	ax  = plt.subplot(111)

	colors = ['orange', 'blue', 'red', 'navy', 'violet', 'maroon']
	for i, comb_name in enumerate(comb_methods):
		crt_y = df[comb_name].values
		plt.plot(x, crt_y, linestyle='--', marker='o', color = colors[i])

	plt.xticks(x, plt_xticks)
	
	ax.set_xlabel('Samples per class')
	ax.set_ylabel('Classification error')
	plt.title(plt_title)

	box = ax.get_position()
	ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
	plt.legend(comb_methods, loc='center left', bbox_to_anchor=(1, 0.5),
		fancybox=True, shadow=True)

	plt.savefig(plt_filename)
	plt.close()

if __name__ == "__main__":
	make_comb_err_plot("scenario1_results_comb.csv", "scenario1_hog_comb.jpg", 
		"Test results using multiple stacked HOG features combining methods of non-linear classifiers for Scenario 1")
	make_comb_err_plot("scenario1_results_comb_ldc.csv", "scenario1_hog_comb_ldc.jpg", 
		"Test results using multiple stacked HOG features combining methods of non-linear and linear classifiers for Scenario 1")
	make_comb_err_plot("scenario2_results_comb.csv", "scenario2_hog_comb.jpg", 
		"Test results using multiple stacked HOG features combining methods for Scenario 2")
	
