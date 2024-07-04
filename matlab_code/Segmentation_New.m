function [image_seg] = Segmentation_New(filename, mask_label, number, m, n)

%% Read the image
I1 = imread(filename);
I1 = imfill(I1, "holes");

%figure()
%imshow(I1)

Test_img_1 = double(I1);

image_seg = zeros(number,m,n,3);

for kk = 1:number
    image_seg(kk,:,:,1) = Test_img_1(:,:,1) .* squeeze(mask_label(kk,:,:));
    image_seg(kk,:,:,2) = Test_img_1(:,:,2) .* squeeze(mask_label(kk,:,:));
    image_seg(kk,:,:,3) = Test_img_1(:,:,3) .* squeeze(mask_label(kk,:,:));
end

%% Convert Image Segmentation to uint8

image_seg = uint8(image_seg);

