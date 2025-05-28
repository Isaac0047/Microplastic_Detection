%% This code does the classification problem 
clear all
close all
clc

%% Note to images
% Image Labels: 1(ABS) 2(EPS) 3(HDPE) 4(LDPE) 5(PA) 6(PC) 7(PET) 8(PP) 9(PS) 10(PVC)
% 1-5:  No Filter (Nil)
% 6-10: Green
% 11-15: Yellow
% 16-20: Orange
% 21-25: Red

%% Load the color space data
RGB = load('RGB_color_space_Test.mat');
HSV = load('HSV_color_space_test.mat');

RGB_color = RGB.RGB_color_space;
HSV_color = HSV.HSV_color_space;

%% Same Filter, Different Wavelength

RGB_265 = RGB_color([1,6,11,16],:,:);  % Wavelength 265
HSV_265 = HSV_color([1,6,11,16],:,:);

RGB_310 = RGB_color([2,7,12,17],:,:);  % Wavelength 265
HSV_310 = HSV_color([2,7,12,17],:,:);

RGB_365 = RGB_color([3,8,13,18],:,:);  % Wavelength 265
HSV_365 = HSV_color([3,8,13,18],:,:);

RGB_410 = RGB_color([4,9,14,19],:,:);  % Wavelength 265
HSV_410 = HSV_color([4,9,14,19],:,:);

RGB_465 = RGB_color([5,10,15,20],:,:);  % Wavelength 265
HSV_465 = HSV_color([5,10,15,20],:,:);

%% Swap the axis of the color matrix

RGB_265 = permute(RGB_265, [2,1,3]);
HSV_265 = permute(HSV_265, [2,1,3]);

RGB_310 = permute(RGB_310, [2,1,3]);
HSV_310 = permute(HSV_310, [2,1,3]);

RGB_365 = permute(RGB_365, [2,1,3]);
HSV_365 = permute(HSV_365, [2,1,3]);

RGB_410 = permute(RGB_410, [2,1,3]);
HSV_410 = permute(HSV_410, [2,1,3]);

RGB_465 = permute(RGB_465, [2,1,3]);
HSV_465 = permute(HSV_465, [2,1,3]);

%% Plotting HSV in Cartesian

num_fil = 4;
num_wav = 5;

total_num = num_fil * num_wav;
[Hm, Hn, Hp] = size(HSV_465);

HSV_color_cart = zeros(total_num,Hm,Hp);

for i = 1:total_num
    for j = 1:Hm

        HSV_color_cart(i,j,1) = HSV_color(i,j,2) * cos(HSV_color(i,j,1)*pi/180);
        HSV_color_cart(i,j,2) = HSV_color(i,j,2) * sin(HSV_color(i,j,1)*pi/180);
        HSV_color_cart(i,j,3) = HSV_color(i,j,3);

    end
end

%% Plotting HSV with different wavelength

HSV_265_cart = HSV_color_cart([1,6,11,16],:,:);
HSV_310_cart = HSV_color_cart([2,7,12,17],:,:);
HSV_365_cart = HSV_color_cart([3,8,13,18],:,:);
HSV_410_cart = HSV_color_cart([4,9,14,19],:,:);
HSV_465_cart = HSV_color_cart([5,10,15,20],:,:);

%% Swap the axis of the color matrix

HSV_265_cart = permute(HSV_265_cart, [2,1,3]);
HSV_310_cart = permute(HSV_310_cart, [2,1,3]);
HSV_365_cart = permute(HSV_365_cart, [2,1,3]);
HSV_410_cart = permute(HSV_410_cart, [2,1,3]);
HSV_465_cart = permute(HSV_465_cart, [2,1,3]);


%% Compute the mean and standard deviation

HSV_ABS_mean  = load('HSV_mean_ABS.mat');
HSV_EPS_mean  = load('HSV_mean_EPS.mat');
HSV_HDPE_mean = load('HSV_mean_HDPE.mat');
HSV_LDPE_mean = load('HSV_mean_LDPE.mat');
HSV_PA_mean   = load('HSV_mean_PA.mat');
HSV_PC_mean   = load('HSV_mean_PC.mat');
HSV_PET_mean  = load('HSV_mean_PET.mat');
HSV_PP_mean   = load('HSV_mean_PP.mat');
HSV_PS_mean   = load('HSV_mean_PS.mat');
HSV_PVC_mean  = load('HSV_mean_PVC.mat');

HSV_ABS_std  = load('HSV_std_ABS.mat');
HSV_EPS_std  = load('HSV_std_EPS.mat');
HSV_HDPE_std = load('HSV_std_HDPE.mat');
HSV_LDPE_std = load('HSV_std_LDPE.mat');
HSV_PA_std   = load('HSV_std_PA.mat');
HSV_PC_std   = load('HSV_std_PC.mat');
HSV_PET_std  = load('HSV_std_PET.mat');
HSV_PP_std   = load('HSV_std_PP.mat');
HSV_PS_std   = load('HSV_std_PS.mat');
HSV_PVC_std  = load('HSV_std_PVC.mat');

HSV_ABS_mean  = HSV_ABS_mean.HSV_G1_mean;
HSV_EPS_mean  = HSV_EPS_mean.HSV_G1_mean;
HSV_HDPE_mean = HSV_HDPE_mean.HSV_G1_mean;
HSV_LDPE_mean = HSV_LDPE_mean.HSV_G1_mean;
HSV_PA_mean   = HSV_PA_mean.HSV_G1_mean;
HSV_PC_mean   = HSV_PC_mean.HSV_G1_mean;
HSV_PET_mean  = HSV_PET_mean.HSV_G1_mean;
HSV_PP_mean   = HSV_PP_mean.HSV_G1_mean;
HSV_PS_mean   = HSV_PS_mean.HSV_G1_mean;
HSV_PVC_mean  = HSV_PVC_mean.HSV_G1_mean;

HSV_ABS_std   = HSV_ABS_std.HSV_G1_std;
HSV_EPS_std   = HSV_EPS_std.HSV_G1_std;
HSV_HDPE_std  = HSV_HDPE_std.HSV_G1_std;
HSV_LDPE_std  = HSV_LDPE_std.HSV_G1_std;
HSV_PA_std    = HSV_PA_std.HSV_G1_std;
HSV_PC_std    = HSV_PC_std.HSV_G1_std;
HSV_PET_std   = HSV_PET_std.HSV_G1_std;
HSV_PP_std    = HSV_PP_std.HSV_G1_std;
HSV_PS_std    = HSV_PS_std.HSV_G1_std;
HSV_PVC_std   = HSV_PVC_std.HSV_G1_std;

%% Permute HSV_color_cart with HSV_Groups
HSV_cart = permute(HSV_color_cart, [2,1,3]);

%% Classification by computing the distance to the mean center

num_mat = 10;
Distance = zeros(Hm,num_mat);

for i = 1:Hm
    Distance(i,1)  = norm(squeeze(HSV_cart(i,:,:))-HSV_ABS_mean);
    Distance(i,2)  = norm(squeeze(HSV_cart(i,:,:))-HSV_EPS_mean);
    Distance(i,3)  = norm(squeeze(HSV_cart(i,:,:))-HSV_HDPE_mean);
    Distance(i,4)  = norm(squeeze(HSV_cart(i,:,:))-HSV_LDPE_mean);
    Distance(i,5)  = norm(squeeze(HSV_cart(i,:,:))-HSV_PA_mean);
    Distance(i,6)  = norm(squeeze(HSV_cart(i,:,:))-HSV_PC_mean);
    Distance(i,7)  = norm(squeeze(HSV_cart(i,:,:))-HSV_PET_mean);
    Distance(i,8)  = norm(squeeze(HSV_cart(i,:,:))-HSV_PP_mean);
    Distance(i,9)  = norm(squeeze(HSV_cart(i,:,:))-HSV_PS_mean);
    Distance(i,10) = norm(squeeze(HSV_cart(i,:,:))-HSV_PVC_mean);
end

Index = zeros(Hm,1);

for i = 1:Hm

    [~,I] = min(Distance(i,:));
    Index(i) = I;

end

[~, idx] = min(Index);
fprintf('The label of microplastics is %d\n', idx);