clear all
close all
clc

% Step 1: Load the Image
img_name = 'Biosolid-20.JPG';
pixelSize_microns = 24.6; % Microns per pixel
I = imread(img_name);

% Step 2: Convert Image to YCbCr Color Space
YCBCR = rgb2ycbcr(I);

% Step 3: Apply K-means Clustering
k = 4; % Number of clusters
[L, C] = imsegkmeans(YCBCR, k); % Perform K-means clustering
clusteredImg = labeloverlay(I, L); % Overlay clustering results on the original image

% Display the clustered image with overlay
figure();
imshow(clusteredImg);
title('Segmented Image with 3 Clusters');

% Step 4: Display each cluster separately for user selection
[m, n] = size(L);
clusters = cell(1, k); % Initialize cell array to store cluster masks

for clusterIdx = 1:k
    clusters{clusterIdx} = (L == clusterIdx); % Create binary mask for each cluster
    
    % Show each cluster
    figure();
    imshow(clusters{clusterIdx});
    title(['Cluster ' num2str(clusterIdx)]);
end

% Step 5: User selects the cluster to use as mask
prompt = 'Enter the cluster number (1, 2, or 3) to use as the mask: ';
userSelection = input(prompt);

% Ensure valid selection
while userSelection < 1 || userSelection > k
    userSelection = input('Invalid selection. Please enter 1, 2, or 3: ');
end




% Step 6: Use the selected cluster as the mask
selectedMask = clusters{userSelection};

% Apply additional filtering to remove small objects
minObjectSize = 100; % Define the minimum object size for filtering
selectedMaskFiltered = bwareafilt(selectedMask, [minObjectSize, 1000000]); % Filter objects based on size

% Apply imfill to fill holes in the segmented mask
%selectedMaskFiltered = imfill(selectedMaskFiltered, 'holes');

% Display the original image
figure();
imshow(I);
hold on;

% Overlay the filtered mask on the original image with transparency
h = imshow(selectedMaskFiltered); % Show the mask
set(h, 'AlphaData', selectedMaskFiltered * 0.1); % Set transparency (0.5 for 50% transparency)

title(['Selected Mask: Cluster ' num2str(userSelection) ' (Filtered and Transparent)']);
hold off;



% regionprops outputs are in pixel units by default
% MajorAxisLength and MinorAxisLength are in pixels
% Area is in square pixels (pixels^2)
% Step 7: Calculate and display statistics for the selected mask
stats = regionprops("table", selectedMaskFiltered, "Centroid", "Area", "Circularity", ...
    "MajorAxisLength", "MinorAxisLength", "Orientation");
% Convert measurements to microns and microns^2
stats.MajorAxisLength_microns = stats.MajorAxisLength * pixelSize_microns;
stats.MinorAxisLength_microns = stats.MinorAxisLength * pixelSize_microns;
stats.Area_microns2 = stats.Area * (pixelSize_microns^2);

% Display the statistics table
disp(['Statistics for Cluster ' num2str(userSelection)]);
disp(stats);

% Step 8: Optional - Save the statistics to a CSV file
writetable(stats, 'particle_dimensions.csv');

% Optional: Save the mask if needed
save('micro_mask_selected.mat', 'selectedMaskFiltered');


