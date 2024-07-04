clear all
close all
clc

%% Merge images

name1 = 'Mask-2.JPG';
%name2 = 'Mask-2.JPG';
%name3 = '1.JPG';

I1 = imread(name1);
I1 = imfill(I1, "holes");

%I2 = imread(name2);
%I2 = imfill(I2, "holes");

%I3 = imread(name3);
%I3 = imfill(I3, "holes");

Inew  = imfuse(I1,   I1, "blend");
%Inew1 = imfuse(Inew, I3, "blend");
%Inew = imfill(Inew);

figure()
imshow(Inew);

%figure()
%imshow(Inew1);

%% Setup YCBR

for i = 2:2
    
    %wavelen = num2str(265);
    %color = ['G','N','R','Y','YO'];
    %name = strcat(wavelen, '-', color(i), '.JPG');
    %name = '8.JPG';

    %I = imread(name);
    %I = imfill(I, "holes");

    I = Inew;
    
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

    I = Inew;

    k = 3;
    [L, C] = imsegkmeans(YCBCR,k);

    B = labeloverlay(I,L);

    figure()
    imshow(B)
    title_name = strcat('Labeled ', Img_col(i), 'Image YCbCr');
    title(title_name)

    k = 3;
    LL = imsegkmeans(I,k);

    BB = labeloverlay(I,LL);

    figure()
    imshow(BB)
    title_name = strcat('Labeled ', Img_col(i), 'Image Original');
    title(title_name)

    %% Find the locations of different groups 

    [m,n,p] = size(I);

    G1 = zeros(m,n);
    G2 = zeros(m,n);
    G3 = zeros(m,n);

    for ii=1:m
        for jj=1:n

            if L(ii,jj) == 1
                G1(ii,jj) = 1;
            elseif L(ii,jj) == 2
                G2(ii,jj) = 1;
            elseif L(ii,jj) == 3
                G3(ii,jj) = 1;
            end

        end
    end

    %% Plot the subregions
    figure()
    imshow(G1)
    title_name = strcat('The first group of Image ', Img_col(i));
    title(title_name)
    colorbar();

    figure()
    imshow(G2)
    title_name = strcat('The second group of Image ', Img_col(i));
    title(title_name)
    colorbar();

    figure()
    imshow(G3)
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
    
end

%% Save the mask

save('micro_mask_22_LDPE_F.mat','G2');
