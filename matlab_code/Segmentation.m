function [stats, mask_label, image_seg, number] = Segmentation(filename, mask)

%% Read the image
I1 = imread(filename);
I1 = imfill(I1, "holes");

figure()
imshow(I1)

%% Apply mask to different images

% I1_new = I1;
% I1_new(:,:,1) = I1(:,:,1) .* mask;
% I1_new(:,:,2) = I1(:,:,2) .* mask;
% I1_new(:,:,3) = I1(:,:,3) .* mask;

%% Extract the Stats

G3b = bwareafilt(mask == 1, [10000, inf]);
stats = regionprops("table", G3b, "Centroid", "Area", "Circularity", "MajorAxisLength", "MinorAxisLength", "Orientation");

%display_name = strcat('The Image Statistics');
%display(display_name)
%stats

%% Get the color of each region Example

k = 10;
[L, C] = imsegkmeans(mask,k);

B = labeloverlay(mask,L);

% figure()
% imshow(B)
% title_name = strcat('Labeled Image');
% title(title_name)

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
    %figure()
    %imshow(thisBlob, []);
end

%% Check the mask for different images

%Test_img = 'IMG_0001_1.JPG';
%Test_img = imread(Test_img);

Test_img_1 = double(I1);

image_seg = zeros(number,m,n,3);

for kk = 1:number
    image_seg(kk,:,:,1) = Test_img_1(:,:,1) .* squeeze(mask_label(kk,:,:));
    image_seg(kk,:,:,2) = Test_img_1(:,:,2) .* squeeze(mask_label(kk,:,:));
    image_seg(kk,:,:,3) = Test_img_1(:,:,3) .* squeeze(mask_label(kk,:,:));
end

%% Convert Image Segmentation to uint8

image_seg = uint8(image_seg);