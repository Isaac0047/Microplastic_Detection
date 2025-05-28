%% This code does the stochastic classification problem 
clear all
close all
clc

%% Note to images
% Image Labels: 1(HDPE) 2(LDPE) 3(PP) 4(PS) 5(PET) 6(ABS)
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

%%
% This code focus on computing the Nearest Neighbor with confidence, please
% change them here

HDPE_mean = load('HSV_mean_HDPE.mat');
HDPE_mean = HDPE_mean.HSV_G1_mean;
LDPE_mean = load('HSV_mean_LDPE.mat');
LDPE_mean = LDPE_mean.HSV_G1_mean;
PP_mean   = load('HSV_mean_PP.mat');
PP_mean   = PP_mean.HSV_G1_mean;
PS_mean   = load('HSV_mean_PS.mat');
PS_mean   = PS_mean.HSV_G1_mean;
PET_mean  = load('HSV_mean_PET.mat');
PET_mean  = PET_mean.HSV_G1_mean;
ABS_mean  = load('HSV_mean_ABS.mat');
ABS_mean  = ABS_mean.HSV_G1_mean;

HDPE_std = load('HSV_std_HDPE.mat');
HDPE_std = HDPE_std.HSV_G1_std;
LDPE_std = load('HSV_std_LDPE.mat');
LDPE_std = LDPE_std.HSV_G1_std;
PP_std   = load('HSV_std_PP.mat');
PP_std   = PP_std.HSV_G1_std;
PS_std   = load('HSV_std_PS.mat');
PS_std   = PS_std.HSV_G1_std;
PET_std  = load('HSV_std_PET.mat');
PET_std  = PET_std.HSV_G1_std;
ABS_std  = load('HSV_std_ABS.mat');
ABS_std  = ABS_std.HSV_G1_std;

test_hsv  = load('HSV_color_space_Test.mat');
test_hsv  = test_hsv.HSV_color_space;
test_hsv  = permute(test_hsv, [2,1,3]);

%% Compute Mahalanobis Distance

% Compute PP_PE_hsv
[m1,~,~] = size(test_hsv);
D_plastic_hdpe = zeros(m1,1);
D_plastic_ldpe = zeros(m1,1);
D_plastic_pp   = zeros(m1,1);
D_plastic_ps   = zeros(m1,1);
D_plastic_pet  = zeros(m1,1);
D_plastic_abs  = zeros(m1,1);

for i=1:m1
    for j=1:20

        cov_mtx1 = diag(HDPE_std(j,:))^2;
        x1       = reshape(test_hsv(i,j,:), 3, 1);
        mu1      = reshape(HDPE_mean(j,:), 3, 1);
        D_plastic_hdpe(i,j) = sqrt(transpose((x1-mu1)) * cov_mtx1 * (x1-mu1));

        cov_mtx2 = diag(LDPE_std(j,:))^2;
        x2       = reshape(test_hsv(i,j,:), 3, 1);
        mu2      = reshape(LDPE_mean(j,:), 3, 1);
        D_plastic_ldpe(i,j) = sqrt(transpose((x2-mu2)) * cov_mtx2 * (x2-mu2));

        cov_mtx3 = diag(PP_std(j,:))^2;
        x3       = reshape(test_hsv(i,j,:), 3, 1);
        mu3      = reshape(PP_mean(j,:), 3, 1);
        D_plastic_pp(i,j) = sqrt(transpose((x3-mu3)) * cov_mtx3 * (x3-mu3));

        cov_mtx4 = diag(PS_std(j,:))^2;
        x4       = reshape(test_hsv(i,j,:), 3, 1);
        mu4      = reshape(PS_mean(j,:), 3, 1);
        D_plastic_ps(i,j) = sqrt(transpose((x4-mu4)) * cov_mtx4 * (x4-mu4));

        cov_mtx5 = diag(PET_std(j,:))^2;
        x5       = reshape(test_hsv(i,j,:), 3, 1);
        mu5      = reshape(PET_mean(j,:), 3, 1);
        D_plastic_pet(i,j) = sqrt(transpose((x5-mu5)) * cov_mtx5 * (x5-mu5));

        cov_mtx6 = diag(ABS_std(j,:))^2;
        x6       = reshape(test_hsv(i,j,:), 3, 1);
        mu6      = reshape(ABS_mean(j,:), 3, 1);
        D_plastic_abs(i,j) = sqrt(transpose((x6-mu6)) * cov_mtx6 * (x6-mu6));

    end
end

%% Save the Mahalanobis Distance

save('plastic_mahal_hdpe.mat', "D_plastic_hdpe")
save('plastic_mahal_ldpe.mat', "D_plastic_ldpe")
save('plastic_mahal_pp.mat',   "D_plastic_pp")
save('plastic_mahal_ps.mat',   "D_plastic_ps")
save('plastic_mahal_pet.mat',  "D_plastic_pet")
save('plastic_mahal_abs.mat',  "D_plastic_abs")

%% Incorporate Confidence Level

alpha = 0.05;
p = 3;

SF = chi2inv(1-alpha, p);

D_plastic_hdpe_sf = D_plastic_hdpe * SF;
D_plastic_ldpe_sf = D_plastic_ldpe * SF;
D_plastic_pp_sf   = D_plastic_pp   * SF;
D_plastic_ps_sf   = D_plastic_ps   * SF;
D_plastic_pet_sf  = D_plastic_pet  * SF;
D_plastic_abs_sf  = D_plastic_abs  * SF;

%% Classification by computing the distance to the mean center
num_mat = 7;

Index = zeros(Hm,1);
Dist_plastic = [vecnorm(D_plastic_hdpe,2,2),vecnorm(D_plastic_ldpe,2,2),vecnorm(D_plastic_pp,2,2),vecnorm(D_plastic_ps,2,2),vecnorm(D_plastic_pet,2,2),vecnorm(D_plastic_abs,2,2)];
%Dist_organ   = [vecnorm(D_organ_hdpe,2,2),  vecnorm(D_organ_ldpe,2,2),  vecnorm(D_organ_pp,2,2)];

%Dist_organ_array   = reshape(Dist_organ,   m2, 3);
Dist_plastic_array = reshape(Dist_plastic, m1, 6);

for i = 1:Hm

    [~,I]    = min(Dist_plastic_array(i,:));
    Index(i) = I;

end

[~, idx] = min(Index);
fprintf('The label of microplastics is %d\n', idx);