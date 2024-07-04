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

%% Plotting the distance for visualization

% figure()
% hold on
% grid on
% plot(D_organ_hdpe,'r*')
% plot(D_plastic_hdpe,'b*')
% title('HDPE distance comparison')
% legend('Organ','Plastic')

% figure()
% hold on
% grid on
% plot(mean(D_organ_hdpe,2),  'r*')
% plot(mean(D_plastic_hdpe,2),'b*')
% title('HDPE mean distance comparison')
% legend('Organ','Plastic')

% figure()
% hold on
% grid on
% plot(vecnorm(D_organ_hdpe,  2,2),'r*')
% plot(vecnorm(D_plastic_hdpe,2,2),'b*')
% title('HDPE norm-2 distance comparison')
% legend('Organ','Plastic')

% figure()
% hold on
% grid on
% plot(vecnorm(D_organ_ldpe,  2,2), 'r*')
% plot(vecnorm(D_plastic_ldpe,2,2), 'b*')
% title('LDPE norm-2 distance comparison')
% legend('Organ','Plastic')

% figure()
% hold on
% grid on
% plot(vecnorm(D_organ_pp,  2,2),'r*')
% plot(vecnorm(D_plastic_pp,2,2),'b*')
% title('PP norm-2 distance comparison')
% legend('Organ','Plastic')

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

%%