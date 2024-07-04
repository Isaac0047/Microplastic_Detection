This folder includes matlab code for the analysis

Step 0: Loading the dataset (microplastic images)

Step 1: running 'Official_Code_Kmeans_Step1.m' to conduct K-Means Clustering for generating the black-and-white individual mask for each detected microplastics saved in .mat file

Step 2: running 'Image_classification_Step2.m', taking .mat generated in Step1, and extract the HSV&RGB colors in each individual plastics

Step 3: running 'micro_classification_hsv_plot_no_nil_Step3_Test.m', taking the HSV/RGB color space stored in Step 2, and compute the mean and variance of each microplastics

Step 4 (Classification): running the 'MD_Dist.m' to compute the Mahalanobis Distance between different pair of microplastics
