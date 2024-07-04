clear all
close all
clc

%% Load the mask file

mask = load("micro_mask_34_ABS.mat");
mask = mask.G3;
mask = uint8(mask);

%% Load the data

name1 = '1.JPG';
name2 = '5.JPG';
name3 = '10.JPG';
name4 = '15.JPG';
name5 = '20.JPG';

I1 = imread(name1);
I1 = imfill(I1, "holes");

I2 = imread(name2);
I2 = imfill(I2, "holes");

I3 = imread(name3);
I3 = imfill(I3, "holes");

I4 = imread(name4);
I4 = imfill(I2, "holes");

I5 = imread(name5);
I5 = imfill(I5, "holes");

%% Apply mask to different images

I1_new = I1;
I1_new(:,:,1) = I1(:,:,1) .* mask;
I1_new(:,:,2) = I1(:,:,2) .* mask;
I1_new(:,:,3) = I1(:,:,3) .* mask;

I2_new = I2;
I2_new(:,:,1) = I2(:,:,1) .* mask;
I2_new(:,:,2) = I2(:,:,2) .* mask;
I2_new(:,:,3) = I2(:,:,3) .* mask;

I3_new = I3;
I3_new(:,:,1) = I3(:,:,1) .* mask;
I3_new(:,:,2) = I3(:,:,2) .* mask;
I3_new(:,:,3) = I3(:,:,3) .* mask;

I4_new = I4;
I4_new(:,:,1) = I4(:,:,1) .* mask;
I4_new(:,:,2) = I4(:,:,2) .* mask;
I4_new(:,:,3) = I4(:,:,3) .* mask;

I5_new = I5;
I5_new(:,:,1) = I5(:,:,1) .* mask;
I5_new(:,:,2) = I5(:,:,2) .* mask;
I5_new(:,:,3) = I5(:,:,3) .* mask;

%% Plot the result

figure(1)
subplot(1,2,1)
imshow(I1)
title('Original Image Sample 1')

subplot(1,2,2)
imshow(I1_new)
title('Masked Image Sample 1')

figure(2)
subplot(1,2,1)
imshow(I2)
title('Original Image Sample 2')

subplot(1,2,2)
imshow(I2_new)
title('Masked Image Sample 2')

figure(3)
subplot(1,2,1)
imshow(I3)
title('Original Image Sample 3')

subplot(1,2,2)
imshow(I3_new)
title('Masked Image Sample 3')

figure(4)
subplot(1,2,1)
imshow(I4)
title('Original Image Sample 4')

subplot(1,2,2)
imshow(I4_new)
title('Masked Image Sample 4')

figure(5)
subplot(1,2,1)
imshow(I5)
title('Original Image Sample 5')

subplot(1,2,2)
imshow(I5_new)
title('Masked Image Sample 5')

%% Plot the mask

G3b = bwareafilt(mask == 1, [10000, inf]);
stats = regionprops("table",G3b,"Centroid", "Area", "Circularity", "MajorAxisLength", "MinorAxisLength", "Orientation");

display_name = strcat('The Image Statistics');
display(display_name)
stats

%% Get the color of each region Example

k = 10;
[L, C] = imsegkmeans(mask,k);

B = labeloverlay(mask,L);

figure()
imshow(B)
title_name = strcat('Labeled Image');
title(title_name)

%% Split individual masks

mask_bw     = imbinarize(mask);
mask_bw_new = bwareafilt(mask_bw == 1, [10000, inf]);

[L, number] = bwlabel(mask_bw_new);

[m,n,p] = size(I1);

mask_label = zeros(number,m,n);

for k = 1 : number
    thisBlob = ismember(L, k);
    %imfill(thisBlob);
    mask_label(k,:,:) = thisBlob;
    figure()
    imshow(thisBlob, []);
end



