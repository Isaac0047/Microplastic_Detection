clear all
close all
clc

%% Setup YCBR
    
i = 1;

wavelen = num2str(265);
color = ['G','N','R','Y','YO'];
%name = strcat(wavelen, '-', color(i), '.JPG');
name = 'IMG_0009.JPG';

I = imread(name);
I = imfill(I, "holes");

Img_col = ["Green","Nil", "Red", "Yellow", "Orange"];

YCBCR = rgb2ycbcr(I);

figure()
imshow(I);
title_name = strcat(Img_col(i), ' Image in RGB Color Space');
title(title_name);

figure()
imshow(YCBCR);
title_name = strcat(Img_col(i), ' Image in YCbCr Color Space');
title(title_name);

%% Use K means Clustering

k = 3;
[L, C] = imsegkmeans(YCBCR,k);

B = labeloverlay(I,L);

figure()
imshow(B)
title_name = strcat('Labeled ', Img_col(i), 'Image YCbCr');
title(title_name)

k = 4;
LL = imsegkmeans(I,k);

BB = labeloverlay(I,LL);

figure()
imshow(BB)
title_name = strcat('Labeled ', Img_col(i), 'Image Original');
title(title_name)

%% Find the locations of different groups 

[m,n,p] = size(I);

G1 = zeros(5,m,n);
G2 = zeros(5,m,n);
G3 = zeros(5,m,n);

for ii=1:m
    for jj=1:n

        if L(ii,jj) == 1
            G1(i,ii,jj) = 1;
        elseif L(ii,jj) == 2
            G2(i,ii,jj) = 1;
        elseif L(ii,jj) == 3
            G3(i,ii,jj) = 1;
        end

    end
end

%% Plot the subregions
figure()
imshow(squeeze(G1(i,:,:)))
title_name = strcat('The first group of Image ', Img_col(i));
title(title_name)
colorbar();

figure()
imshow(squeeze(G2(i,:,:)))
title_name = strcat('The second group of Image ', Img_col(i));
title(title_name)
colorbar();

figure()
imshow(squeeze(G3(i,:,:)))
title_name = strcat('The third group of Image ', Img_col(i));
title(title_name)
colorbar();

%% Plot the Group from the Kmeans Clustering (This works well)
G1_mean = mean(mean(squeeze(G1(i,:,:))));
G2_mean = mean(mean(squeeze(G2(i,:,:))));
G3_mean = mean(mean(squeeze(G3(i,:,:))));

G_mean = [G1_mean, G2_mean, G3_mean];
[GC, GI] = min(G_mean);

if GI==1
    G3L = logical(squeeze(G1(i,:,:)));
elseif GI==2
    G3L = logical(squeeze(G2(i,:,:)));
elseif GI==3
    G3L = logical(squeeze(G3(i,:,:)));
end

% G3L = logical(G2);
G3b = bwareafilt(G3L == 1, [10000, inf]);
stats = regionprops("table",G3b,"Centroid", "Area", "Circularity", "MajorAxisLength", "MinorAxisLength", "Orientation");

display_name = strcat(Img_col(i), ' Image Statistics');
display(display_name)
stats

s = regionprops(G3b, 'PixelIdxList');
meanI1 = zeros(numel(s),1);
meanI2 = zeros(numel(s),1);
meanI3 = zeros(numel(s),1);

I_hsv = rgb2hsv(I);

for n=1:numel(s)
    I1 = I(:,:,1);
    I2 = I(:,:,2);
    I3 = I(:,:,3);
    meanI1(n,1) = mean(I1(s(n).PixelIdxList));
    meanI2(n,1) = mean(I2(s(n).PixelIdxList));
    meanI3(n,1) = mean(I3(s(n).PixelIdxList));
end

mean_rgb = [meanI1, meanI2, meanI3];
display_name = strcat(Img_col(i), ' Image Mean RGB');
display(display_name)
mean_rgb

for n=1:numel(s)
    I1 = I_hsv(:,:,1);
    I2 = I_hsv(:,:,2);
    I3 = I_hsv(:,:,3);
    meanI1(n,1) = mean(I1(s(n).PixelIdxList));
    meanI2(n,1) = mean(I2(s(n).PixelIdxList));
    meanI3(n,1) = mean(I3(s(n).PixelIdxList));
end

mean_hsv = [meanI1, meanI2, meanI3];
display_name = strcat(Img_col(i), ' Image Mean HSV');
display(display_name)
mean_hsv

%% Validate the location
if numel(s)==8
    pos = [int64(stats.Centroid(1,1)) int64(stats.Centroid(1,2)); int64(stats.Centroid(2,1)) int64(stats.Centroid(2,2)); ...
         int64(stats.Centroid(3,1)) int64(stats.Centroid(3,2)); int64(stats.Centroid(4,1)) int64(stats.Centroid(4,2)); ...
         int64(stats.Centroid(5,1)) int64(stats.Centroid(5,2)); int64(stats.Centroid(6,1)) int64(stats.Centroid(6,2)); ...
         int64(stats.Centroid(7,1)) int64(stats.Centroid(7,2)); int64(stats.Centroid(8,1)) int64(stats.Centroid(8,2));];

    color = {'red','white','green','yellow','cyan','magenta','black','blue'};
    % color = {'red','white','green','yellow','cyan','magenta'};
    mark  = {'o','x','s','+','o','x','s','+'};
    figure()
    RGB = insertMarker(I, pos, 's', 'color', color, 'size', 40);
    imshow(RGB)
    title_name = strcat(Img_col(i), ' Image with Marker of 8');
    title(title_name)

elseif numel(s)==6
     pos = [int64(stats.Centroid(1,1)) int64(stats.Centroid(1,2)); int64(stats.Centroid(2,1)) int64(stats.Centroid(2,2)); ...
     int64(stats.Centroid(3,1)) int64(stats.Centroid(3,2)); int64(stats.Centroid(4,1)) int64(stats.Centroid(4,2)); ...
     int64(stats.Centroid(5,1)) int64(stats.Centroid(5,2)); int64(stats.Centroid(6,1)) int64(stats.Centroid(6,2));];

     color = {'red','white','green','yellow','cyan','magenta'};
     mark  = {'o','x','s','+','o','x','s','+'};
     figure()
     RGB = insertMarker(I, pos, 's', 'color', color, 'size', 40);
     imshow(RGB)
     title_name = strcat(Img_col(i), ' Image with Marker of 6');
     title(title_name)

elseif numel(s)==7
     pos = [int64(stats.Centroid(1,1)) int64(stats.Centroid(1,2)); int64(stats.Centroid(2,1)) int64(stats.Centroid(2,2)); ...
     int64(stats.Centroid(3,1)) int64(stats.Centroid(3,2)); int64(stats.Centroid(4,1)) int64(stats.Centroid(4,2)); ...
     int64(stats.Centroid(5,1)) int64(stats.Centroid(5,2)); int64(stats.Centroid(6,1)) int64(stats.Centroid(6,2)); ...
     int64(stats.Centroid(7,1)) int64(stats.Centroid(7,2));];

     color = {'red','white','green','yellow','cyan','magenta','blue'};
     mark  = {'o','x','s','+','o','x','s','+'};
     figure()
     RGB = insertMarker(I, pos, 's', 'color', color, 'size', 40);
     imshow(RGB)
     title_name = strcat(Img_col(i), ' Image with Marker of 7');
     title(title_name)

end

%% Image Mask

G3m = squeeze(G3(1,:,:));


%% Sampling points along major and minor axis

ori   = stats.Orientation;
major = stats.MajorAxisLength;
minor = stats.MinorAxisLength;

[mm,nn] = size(stats.Centroid);
dm = zeros(mm,2);
dn = zeros(mm,2);

for iii=1:mm
    
    x = stats.Centroid(iii,1);
    y = stats.Centroid(ii,2);
    theta   = stats.Orientation(iii);
    delta   = stats.MajorAxisLength(iii);
    epsilon = stats.MinorAxisLength(iii);
    
    [dm(iii,1),dm(iii,2),dn(iii,1),dn(iii,2)] = transform(x, y, delta/2, epsilon/2, theta);
    
end

pos = [];

for ii=1:mm
    pos(end+1) = [dm(ii,1),dm(ii,2)];
%     pos(end+1) = dm(ii,2);
    pos(end+1) = [dn(ii,1),dn(ii,2)];
%     pos(end+1) = dn(ii,2);
end

% pos = [int64(dm(1,1)) int64(dm(1,2)); int64(dm(2,1)) int64(dm(2,2)); ...
%          int64(dm(3,1)) int64(dm(3,2)); int64(dm(4,1)) int64(dm(4,2)); ...
%          int64(dn(1,1)) int64(dn(1,2)); int64(dn(2,1)) int64(dn(2,2)); ...
%          int64(dn(3,1)) int64(dn(3,2)); int64(dn(4,1)) int64(dn(4,2));];

pos = int64(pos);

color = {'red','white','green','yellow','cyan','magenta','blue','black'};
% color = {'red','white','green','yellow','cyan','magenta','blue','black'};
mark  = {'o','x','s','+','o','x','s','+'};

figure()
II  = squeeze(G3(i,:,:));
RGB = insertMarker(II, pos, 'x', 'color', 'yellow', 'size', 80);
imshow(RGB)
title_name = strcat(Img_col(i), ' Image Max and Min with Marker');
title(title_name)
% saveas(gcf, strcat(title_name, '.png'))

function [xm, ym, xn, yn] = transform(x, y, delta, epsilon, theta)
    
    xm = x + delta * cos(theta);
    ym = y + delta * sin(theta);
    xn = x - epsilon * sin(theta);
    yn = y + epsilon * cos(theta);
    
end
