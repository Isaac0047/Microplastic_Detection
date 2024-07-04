clear all
close all
clc


%% Create Mask on BW iamge

name1 = 'IMG_0008_1.JPG';
name2 = 'IMG_0009.JPG';
name3 = 'IMG_0011_1.JPG';

I1 = imread(name1);
I1 = imfill(I1, "holes");

I2 = imread(name3);
I2 = imfill(I2, "holes");

Igray = rgb2gray(I1);
BW = imbinarize(Igray);

% Delete regions connecting to the image border
BW = imclearborder(BW);
% Fill holes
BW = imfill(BW,'hole');
% Extract the region with maximum size
BW = bwareafilt(BW,1);
% Make a mask
BWmask = ~BW;
% Show the result
figure
imshow(BWmask)