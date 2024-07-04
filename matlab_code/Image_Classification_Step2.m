clear all
close all
clc

%% Load the mask file

mask = load("micro_mask_22_LDPE_F.mat");
mask = mask.G2;
mask = uint8(mask);

[m,n] = size(mask);

%par_num    = 9;
color_chan = 3;

%% Extract feature from mask

low_bound = 500;

% Extract the Stats

G3b   = bwareafilt(mask == 1, [low_bound, inf]);
stats = regionprops("table", G3b, "Centroid", "Area", "Circularity", "MajorAxisLength", "MinorAxisLength", "Orientation");

%display_name = strcat('The Image Statistics');
%display(display_name)
%stats

stats_shape = size(stats.Area);
par_num = stats_shape(1);

% Get the color of each region Example

k = par_num + 1;
[L, C] = imsegkmeans(mask,k);

B = labeloverlay(mask,L);

% figure()
% imshow(B)
% title_name = strcat('Labeled Image');
% title(title_name)

% Split individual masks

mask_bw     = imbinarize(mask);
mask_bw_new = bwareafilt(mask_bw == 1, [low_bound, inf]);

[L, number] = bwlabel(mask_bw_new);

%[m,n,p] = size(I1);

mask_label = zeros(number,m,n);

for k = 1 : number

    thisBlob = ismember(L, k);
    %imfill(thisBlob);
    mask_label(k,:,:) = thisBlob;
    figure()
    imshow(thisBlob, []);

end

%% Initialize parameter spaces
file_num   = 20;

RGB_color_space = zeros(file_num, par_num, color_chan);
HSV_color_space = zeros(file_num, par_num, color_chan);

%% Load the filename 

for i = 1 : file_num

    id = num2str(i);
    filename = strcat(id, '.JPG');

    % Get the Segmentation objects

    [image_seg] = Segmentation_New(filename, mask_label, number, m, n);
    
    [RGB_color, HSV_color] = color(mask_label, image_seg);

    RGB_color_space(i,:,:) = RGB_color;
    HSV_color_space(i,:,:) = HSV_color;

    fprintf('one loop finish\n')

end

% Save the parameters
save('RGB_color_space_LDPE_F.mat', "RGB_color_space");
save('HSV_color_space_LDPE_F.mat', "HSV_color_space");

