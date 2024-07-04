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
RGB = load('RGB_color_space.mat');
HSV = load('HSV_color_space.mat');

RGB_color = RGB.RGB_color_space;
HSV_color = HSV.HSV_color_space;

%% Same Filter, Different Wavelength

RGB_265 = RGB_color([1,6,11,16,21],:,:);  % Wavelength 265
HSV_265 = HSV_color([1,6,11,16,21],:,:);

RGB_310 = RGB_color([2,7,12,17,22],:,:);  % Wavelength 265
HSV_310 = HSV_color([2,7,12,17,22],:,:);

RGB_365 = RGB_color([3,8,13,18,23],:,:);  % Wavelength 265
HSV_365 = HSV_color([3,8,13,18,23],:,:);

RGB_410 = RGB_color([4,9,14,19,24],:,:);  % Wavelength 265
HSV_410 = HSV_color([4,9,14,19,24],:,:);

RGB_465 = RGB_color([5,10,15,20,25],:,:);  % Wavelength 265
HSV_465 = HSV_color([5,10,15,20,25],:,:);

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

%% Write out the matrix

% writematrix(RGB_265,'RGB_265.xlsx');
% writematrix(RGB_310,'RGB_310.xlsx');
% writematrix(RGB_365,'RGB_365.xlsx');
% writematrix(RGB_410,'RGB_410.xlsx');
% writematrix(RGB_465,'RGB_465.xlsx');

%% Write out the HSV matrix

% writematrix(HSV_265,'HSV_265.xlsx');
% writematrix(HSV_310,'HSV_310.xlsx');
% writematrix(HSV_365,'HSV_365.xlsx');
% writematrix(HSV_410,'HSV_410.xlsx');
% writematrix(HSV_465,'HSV_465.xlsx');

%% Plot the color space in RGB Cartesian Axis

[m,n,p] = size(HSV_265);
color = ['r','g','b','r','g','b','r','g','b'];
marker = ['o','o','o','x','x','x','*','*','*'];

figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(RGB_265(i,:,1)),squeeze(RGB_265(i,:,2)),squeeze(RGB_265(i,:,3)),marker(i),color(i));
end

title('RGB 265nm distribution in 3D plot')

figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(RGB_310(i,:,1)),squeeze(RGB_310(i,:,2)),squeeze(RGB_310(i,:,3)),marker(i),color(i));
end

title('RGB 310nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(RGB_365(i,:,1)),squeeze(RGB_365(i,:,2)),squeeze(RGB_365(i,:,3)),marker(i),color(i));
end

title('RGB 365nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(RGB_410(i,:,1)),squeeze(RGB_410(i,:,2)),squeeze(RGB_410(i,:,3)),marker(i),color(i));
end

title('RGB 410nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(RGB_465(i,:,1)),squeeze(RGB_465(i,:,2)),squeeze(RGB_465(i,:,3)),marker(i),color(i));
end

title('RGB 465nm distribution in 3D plot')

%% Draw the HSV Contour in Cartesian

[m,n,p] = size(HSV_265);
color = ['r','g','b','r','g','b','r','g','b'];
marker = ['o','o','o','x','x','x','*','*','*'];

figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(HSV_265(i,:,1)),squeeze(HSV_265(i,:,2)),squeeze(HSV_265(i,:,3)),marker(i),color(i));
end

title('HSV 265nm distribution in 3D plot')

figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(HSV_310(i,:,1)),squeeze(HSV_310(i,:,2)),squeeze(HSV_310(i,:,3)),marker(i),color(i));
end

title('HSV 310nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(HSV_365(i,:,1)),squeeze(HSV_365(i,:,2)),squeeze(HSV_365(i,:,3)),marker(i),color(i));
end

title('HSV 365nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(HSV_410(i,:,1)),squeeze(HSV_410(i,:,2)),squeeze(HSV_410(i,:,3)),marker(i),color(i));
end

title('HSV 410nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    scatter3(squeeze(HSV_465(i,:,1)),squeeze(HSV_465(i,:,2)),squeeze(HSV_465(i,:,3)),marker(i),color(i));
end

title('HSV 465nm distribution in 3D plot')

%% Plotting HSV in Cartesian

HSV_color_cart = zeros(25,9,3);

for i = 1:25
    for j = 1:9

        HSV_color_cart(i,j,1) = HSV_color(i,j,2) * cos(HSV_color(i,j,1)*pi/180);
        HSV_color_cart(i,j,2) = HSV_color(i,j,2) * sin(HSV_color(i,j,1)*pi/180);
        HSV_color_cart(i,j,3) = HSV_color(i,j,3);

    end
end

%% Plotting HSV with different wavelength

HSV_265_cart = HSV_color_cart([1,6,11,16,21],:,:);
HSV_310_cart = HSV_color_cart([2,7,12,17,22],:,:);
HSV_365_cart = HSV_color_cart([3,8,13,18,23],:,:);
HSV_410_cart = HSV_color_cart([4,9,14,19,24],:,:);
HSV_465_cart = HSV_color_cart([5,10,15,20,25],:,:);

%% Swap the axis of the color matrix

HSV_265_cart = permute(HSV_265_cart, [2,1,3]);
HSV_310_cart = permute(HSV_310_cart, [2,1,3]);
HSV_365_cart = permute(HSV_365_cart, [2,1,3]);
HSV_410_cart = permute(HSV_410_cart, [2,1,3]);
HSV_465_cart = permute(HSV_465_cart, [2,1,3]);

%% Plot

[m,n,p] = size(HSV_265_cart);
color = ['r','g','b','r','g','b','r','g','b'];
marker = ['--o r','--o g','--o b','--x r','--x g','--x b','--* r','--* g','--* b'];
linespec = ['-',':','-.','-',':','-.','-',':','-.'];

figure()
hold on
grid on

for i = 1:m
    plot3(squeeze(HSV_265_cart(i,:,1)),squeeze(HSV_265_cart(i,:,2)),squeeze(HSV_265_cart(i,:,3)),marker(i));
end

title('HSV 265nm distribution in 3D plot')

figure()
hold on
grid on

for i = 1:m
    plot3(squeeze(HSV_310_cart(i,:,1)),squeeze(HSV_310_cart(i,:,2)),squeeze(HSV_310_cart(i,:,3)),marker(i));
end

title('HSV 310nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    plot3(squeeze(HSV_365_cart(i,:,1)),squeeze(HSV_365_cart(i,:,2)),squeeze(HSV_365_cart(i,:,3)),marker(i));
end

title('HSV 365nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    plot3(squeeze(HSV_410_cart(i,:,1)),squeeze(HSV_410_cart(i,:,2)),squeeze(HSV_410_cart(i,:,3)),marker(i));
end

title('HSV 410nm distribution in 3D plot')


figure()
hold on
grid on

for i = 1:m
    plot3(squeeze(HSV_465_cart(i,:,1)),squeeze(HSV_465_cart(i,:,2)),squeeze(HSV_465_cart(i,:,3)),marker(i));
end

title('HSV 465nm distribution in 3D plot')

