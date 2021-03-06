% dc Process 1: make bandpass event comparisons

%% colors
dcGreen = 1/255*[68, 170, 68];
dcLightGreen = 1/255*[163, 244, 140];
dcPurple = 1/255*[89, 84, 255];
dcLightPurple = 1/255*[179, 160, 255];
dcRed = 1/255*[224, 17, 73];
dcBlue = 1/255*[66, 185, 255];
cie1 = 1/255*[66, 134, 244];
cie2 = 1/255*[236, 130, 255];
air1 = 1/255*[96, 219, 145];
air2 = 1/255*[195, 247, 74];
%% set things 
Fs      = LFP.freq;
window  = [-3, 3];
channel = 1;
% bands
beta    = [12.5, 30];
theta   = [7, 9];
%% load LFP and behav mats.
% have to be in the folder you want
dirbehav = dir('*_behavior.mat');
load(dirbehav.name)
dirLFP = dir('*_LFP.mat');
load(dirLFP.name)
%% raw session
LFP_air2528 = LFP;
behav_air2528 = behav;
%%
LFP_air2676 = LFP;
behav_air2676 = behav;
%%
LFP_air2677 = LFP;
behav_air2677 = behav;
%%
LFP_CIE2526 = LFP;
behav_CIE2526 = behav;
%%
LFP_CIE2527 = LFP;
behav_CIE2527 = behav;
%%
LFP_CIE2624 = LFP;
behav_CIE2624 = behav;
%% zscore session
z_air2528 = LFP_air2528;
z_air2528.channel{channel}.data = zscore(LFP_air2528.channel{channel}.data);

z_air2676 = LFP_air2676;
z_air2676.channel{channel}.data = zscore(LFP_air2676.channel{channel}.data);

z_air2677 = LFP_air2677;
z_air2677.channel{channel}.data = zscore(LFP_air2677.channel{channel}.data);

z_CIE2526 = LFP_CIE2526;
z_CIE2526.channel{channel}.data = zscore(LFP_CIE2526.channel{channel}.data);

z_CIE2527 = LFP_CIE2527;
z_CIE2527.channel{channel}.data = zscore(LFP_CIE2527.channel{channel}.data);

z_CIE2624 = LFP_CIE2624;
z_CIE2624.channel{channel}.data = zscore(LFP_CIE2624.channel{channel}.data);
%% make data window arrays to feed to meanbandpower
ReinON_zWindows_air2528  = dcMakeDataWindows(z_air2528, behav_air2528, 'ReinON',   window, channel);
ReinON_zWindows_air2676  = dcMakeDataWindows(z_air2676, behav_air2676, 'ReinON',   window, channel);
ReinON_zWindows_air2677  = dcMakeDataWindows(z_air2677, behav_air2677, 'ReinON',   window, channel);
ReinON_zWindows_CIE2526  = dcMakeDataWindows(z_CIE2526, behav_CIE2526, 'ReinON',   window, channel);
ReinON_zWindows_CIE2527  = dcMakeDataWindows(z_CIE2527, behav_CIE2527, 'ReinON',   window, channel);
ReinON_zWindows_CIE2624  = dcMakeDataWindows(z_CIE2624, behav_CIE2624, 'ReinON',   window, channel);
%% make data window arrays to feed to meanbandpower
ReinON_dataWindows_air2528  = dcMakeDataWindows(LFP_air2528, behav_air2528, 'ReinON',   window, channel);
ReinON_dataWindows_air2676  = dcMakeDataWindows(LFP_air2676, behav_air2676, 'ReinON',   window, channel);
ReinON_dataWindows_air2677  = dcMakeDataWindows(LFP_air2677, behav_air2677, 'ReinON',   window, channel);
ReinON_dataWindows_CIE2526  = dcMakeDataWindows(LFP_CIE2526, behav_CIE2526, 'ReinON',   window, channel);
ReinON_dataWindows_CIE2527  = dcMakeDataWindows(LFP_CIE2527, behav_CIE2527, 'ReinON',   window, channel);
ReinON_dataWindows_CIE2624  = dcMakeDataWindows(LFP_CIE2624, behav_CIE2624, 'ReinON',   window, channel);
%%
% make loop
X = ReinON_dataWindows_CIE2624;

% subtract mean of each row
Xnew = X - repmat(mean(X, 2), [1 size(X, 2)]);
% divide Xnew by the stdev
Xnew = Xnew ./ std(Xnew(:));

zReinON_dataWindows_CIE2624 = Xnew;
%%

%zReinON_dataWindows_air2528  = ReinON_dataWindows_air2528
%zReinON_dataWindows_air2676  = zscore(ReinON_dataWindows_air2676);
%zReinON_dataWindows_air2677  = zscore(ReinON_dataWindows_air2677);
%zReinON_dataWindows_CIE2526  = zscore(ReinON_dataWindows_CIE2526);
%zReinON_dataWindows_CIE2527  = zscore(ReinON_dataWindows_CIE2527);
%zReinON_dataWindows_CIE2624  = zscore(ReinON_dataWindows_CIE2624);
%% make mean band power 
%% beta
% betaPower_air2528 = dcMeanBandPower(ReinON_zWindows_air2528, beta, Fs);
% betaPower_air2676 = dcMeanBandPower(ReinON_zWindows_air2676, beta, Fs);
% betaPower_air2677 = dcMeanBandPower(ReinON_zWindows_air2677, beta, Fs);
% betaPower_CIE2526 = dcMeanBandPower(ReinON_zWindows_CIE2526, beta, Fs);
% betaPower_CIE2527 = dcMeanBandPower(ReinON_zWindows_CIE2527, beta, Fs);
% betaPower_CIE2624 = dcMeanBandPower(ReinON_zWindows_CIE2624, beta, Fs);
%%
betaPower_air2528 = dcMeanBandPower(zReinON_dataWindows_air2528, beta, Fs);
betaPower_air2676 = dcMeanBandPower(zReinON_dataWindows_air2676, beta, Fs);
betaPower_air2677 = dcMeanBandPower(zReinON_dataWindows_air2677, beta, Fs);
betaPower_CIE2526 = dcMeanBandPower(zReinON_dataWindows_CIE2526, beta, Fs);
betaPower_CIE2527 = dcMeanBandPower(zReinON_dataWindows_CIE2527, beta, Fs);
betaPower_CIE2624 = dcMeanBandPower(zReinON_dataWindows_CIE2624, beta, Fs);
%%
betaPower_air = [betaPower_air2528; betaPower_air2676; betaPower_air2677];
betaPower_CIE = [betaPower_CIE2526; betaPower_CIE2624; betaPower_CIE2527];
%%
% fix timestamps part, 
% this will fail if the time window is asymmetrical:
% also i have a -1 in here 
timestamps = 0:1/Fs:(size(ReinON_dataWindows_air2528, 2)-1)/Fs;
timestamps = timestamps - median(timestamps); % to shift the middle to zero

%% stats time baby
SEM_beta_air = std(betaPower_air, 0, 1) ./ sqrt(3);
SEM_beta_CIE = std(betaPower_CIE, 0, 1) ./ sqrt(3);
%% t test baby
[Hbeta, p] = ttest2(betaPower_air,betaPower_CIE);
HbetaPlot = Hbeta;
HbetaPlot(HbetaPlot==0) = NaN;
%%
figure(1)
plot(timestamps,mean(betaPower_air), 'LineWidth',2, 'color', dcGreen)
hold on
plot(timestamps,betaPower_air(1,:),'color', air1)
plot(timestamps,betaPower_air(2,:),'color', air2)
plot(timestamps,betaPower_air(3,:),'color', dcLightGreen)
line([0 0], [0 200], 'Color', 'k', 'LineWidth', 0.5,'HandleVisibility','off')
ylim([0 20])
title('Beta Power at Rewarded Lever Presses, Air animals')
xlabel('Time (s)')
ylabel('Beta Power')
legend('Mean Air', 'air 2528','air 2676','air 2677')
set(gca,'FontSize',14)
%%
figure(2)
plot(timestamps,mean(betaPower_CIE), 'LineWidth',2, 'color', dcPurple)
hold on
plot(timestamps,betaPower_CIE(1,:), 'color', cie1)
plot(timestamps,betaPower_CIE(2,:), 'color', cie2)
plot(timestamps,betaPower_CIE(3,:), 'color', dcLightPurple)
line([0 0], [0 200], 'Color', 'k', 'LineWidth', 0.5,'HandleVisibility','off')
title('Beta Power at Rewarded Lever Presses, CIE animals')
xlabel('Time (s)')
ylabel('Beta Power')
ylim([0 20])
legend('Mean CIE', 'CIE 2526','CIE 2624','CIE 2527')
set(gca,'FontSize',14)
%%
figure(3)
plot(timestamps,mean(betaPower_air), 'LineWidth',2, 'color', dcGreen)
hold on
plot(timestamps,mean(betaPower_CIE), 'LineWidth',2, 'color', dcPurple)
title('Average Beta Power at Rewarded Lever Presses, +/- SEM')
xlabel('Time (s)')
ylabel('Beta Power')
ylim([0 20])
legend('air', 'CIE')
set(gca,'FontSize',14)
plot(timestamps,mean(betaPower_air)+SEM_beta_air, 'color', dcLightGreen,'HandleVisibility','off')
plot(timestamps,mean(betaPower_air)-SEM_beta_air, 'color', dcLightGreen,'HandleVisibility','off')
plot(timestamps,mean(betaPower_CIE)+SEM_beta_CIE, 'color', dcLightPurple,'HandleVisibility','off')
plot(timestamps,mean(betaPower_CIE)-SEM_beta_CIE, 'color', dcLightPurple,'HandleVisibility','off')
line([0 0], [0 200], 'Color', 'k', 'LineWidth', 0.5,'HandleVisibility','off')
scatter(timestamps,HbetaPlot+6,20,dcRed,'filled','HandleVisibility','off')

%%
%%
%% theta
% thetaPower_air2528 = dcMeanBandPower(ReinON_zWindows_air2528, theta, Fs);
% thetaPower_air2676 = dcMeanBandPower(ReinON_zWindows_air2676, theta, Fs);
% thetaPower_air2677 = dcMeanBandPower(ReinON_zWindows_air2677, theta, Fs);
% thetaPower_CIE2526 = dcMeanBandPower(ReinON_zWindows_CIE2526, theta, Fs);
% thetaPower_CIE2527 = dcMeanBandPower(ReinON_zWindows_CIE2527, theta, Fs);
% thetaPower_CIE2624 = dcMeanBandPower(ReinON_zWindows_CIE2624, theta, Fs);
%%
thetaPower_air2528 = dcMeanBandPower(zReinON_dataWindows_air2528, theta, Fs);
thetaPower_air2676 = dcMeanBandPower(zReinON_dataWindows_air2676, theta, Fs);
thetaPower_air2677 = dcMeanBandPower(zReinON_dataWindows_air2677, theta, Fs);
thetaPower_CIE2526 = dcMeanBandPower(zReinON_dataWindows_CIE2526, theta, Fs);
thetaPower_CIE2527 = dcMeanBandPower(zReinON_dataWindows_CIE2527, theta, Fs);
thetaPower_CIE2624 = dcMeanBandPower(zReinON_dataWindows_CIE2624, theta, Fs);
%%
thetaPower_air = [thetaPower_air2528; thetaPower_air2676; thetaPower_air2677];
thetaPower_CIE = [thetaPower_CIE2526; thetaPower_CIE2624; thetaPower_CIE2527];
%%
% fix timestamps part, 
% this will fail if the time window is asymmetrical:
% also i have a -1 in here 
timestamps = 0:1/Fs:(size(ReinON_dataWindows_air2528, 2)-1)/Fs;
timestamps = timestamps - median(timestamps); % to shift the middle to zero

%% stats time baby
SEM_theta_air = std(thetaPower_air, 0, 1) ./ sqrt(3);
SEM_theta_CIE = std(thetaPower_CIE, 0, 1) ./ sqrt(3);
%% t test baby
[Htheta, p] = ttest2(thetaPower_air,thetaPower_CIE);
HthetaPlot = Htheta;
HthetaPlot(HthetaPlot==0) = NaN;
%%
figure(4)
plot(timestamps,mean(thetaPower_air), 'LineWidth',2, 'color', dcGreen)
hold on
plot(timestamps,thetaPower_air(1,:),'color', air1)
plot(timestamps,thetaPower_air(2,:),'color', air2)
plot(timestamps,thetaPower_air(3,:),'color', dcLightGreen)
line([0 0], [0 200], 'Color', 'k', 'LineWidth', 0.5,'HandleVisibility','off')
ylim([0 70])
title('Theta Power at Rewarded Lever Presses, Air animals')
xlabel('Time (s)')
ylabel('Theta Power')
legend('Mean Air', 'air 2528','air 2676','air 2677')
set(gca,'FontSize',14)
%%
figure(5)
plot(timestamps,mean(thetaPower_CIE), 'LineWidth',2, 'color', dcPurple)
hold on
plot(timestamps,thetaPower_CIE(1,:), 'color', cie1)
plot(timestamps,thetaPower_CIE(2,:), 'color', cie2)
plot(timestamps,thetaPower_CIE(3,:), 'color', dcLightPurple)
line([0 0], [0 200], 'Color', 'k', 'LineWidth', 0.5,'HandleVisibility','off')
title('Theta Power at Rewarded Lever Presses, CIE animals')
xlabel('Time (s)')
ylabel('Theta Power')
ylim([0 70])
legend('Mean CIE', 'CIE 2526','CIE 2624','CIE 2527')
set(gca,'FontSize',14)

%%
figure(6)
plot(timestamps,mean(thetaPower_air)+SEM_theta_air, '-', 'color', dcLightGreen,'HandleVisibility','off')
hold on
plot(timestamps,mean(thetaPower_air)-SEM_theta_air, 'color', dcLightGreen,'HandleVisibility','off')
plot(timestamps,mean(thetaPower_CIE)+SEM_theta_CIE, 'color', dcLightPurple,'HandleVisibility','off')
plot(timestamps,mean(thetaPower_CIE)-SEM_theta_CIE, 'color', dcLightPurple,'HandleVisibility','off')
plot(timestamps,mean(thetaPower_air), 'LineWidth',2, 'color', dcGreen)
hold on
plot(timestamps,mean(thetaPower_CIE), 'LineWidth',2, 'color', dcPurple)
scatter(timestamps,HthetaPlot+30,20,dcRed,'filled','HandleVisibility','off')
title('Average Theta Power at Rewarded Lever Presses, +/- SEM')
xlabel('Time (s)')
ylabel('Theta Power')
legend('air', 'CIE')
set(gca,'FontSize',14)
ylim([0 70])
line([0 0], [0 140], 'Color', 'k', 'LineWidth', 0.5,'HandleVisibility','off')