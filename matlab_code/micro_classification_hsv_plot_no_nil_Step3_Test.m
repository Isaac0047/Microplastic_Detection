%% This code tries to do the classification problem 
clear all
close all
clc

%% Note to images

% 1-5:  No Filter (Nil)
% 6-10: Green
% 11-15: Yellow
% 16-20: Orange
% 21-25: Red

%% Load the color space data
RGB = load('RGB_color_space_LDPE_F.mat');
HSV = load('HSV_color_space_LDPE_F.mat');

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

RGB_465 = RGB_color([5,10,15,20],:,:); % Wavelength 265
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

%% Permute the HSV_Cart

% Compare HSV_color_cart with HSV_Groups
HSV_cart = permute(HSV_color_cart, [2,1,3]);

%% Compute the mean and standard deviation

HSV_G1_mean = squeeze(mean(HSV_cart));
HSV_G1_std  = squeeze(std(HSV_cart));

%% Save the Mean and Std
save('HSV_mean_LDPE_F.mat', "HSV_G1_mean");
save('HSV_std_LDPE_F.mat',  "HSV_G1_std");
