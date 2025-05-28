This folder includes matlab code for the analysis

Step 0: Loading the dataset (microplastic images)

Step 1: running 'Step1_MP_Detection_Kmeans.m' to conduct K-Means Clustering for generating the black-and-white individual mask for each detected microplastics saved in .mat file

Step 2: running 'Step2_MP_CSF_Extraction.m', taking .mat generated in Step1, and extract the HSV&RGB colors in each individual plastics

Step 3: running 'Step3_stats_extraction.m', taking the HSV/RGB color space stored in Step 2, and compute the mean and variance of each microplastics

Step 4 (Classification): running the 'Step4A_mean_distance.m' to compute the normal distance OR running the 'Step4B_mahalanobis.m' to compute the mahalanobis distance between microplastics

***** NOTE ******

Step1 - Step3 shows the extraction of one microplastic with name 'MPs'. When dealing with multiple microplastics classification, the file saving names need to be changed accordingly. Step 4 data loading names are also subject to change.
