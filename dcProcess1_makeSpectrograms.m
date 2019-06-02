% dc Process 1: make spectrograms

%% colors
dcGreen = 1/255*[68, 170, 68];
dcPurple = 1/255*[166, 38, 164];
dcLightGreen = 1/255*[163, 244, 140];
dcRed = 1/255*[224, 17, 73];
dcBlue = 1/255*[66, 185, 255];
%% load LFP and behav mats.
% have to be in the folder you want
load('air_2676-1600-4_behavior.mat')
load('air_2676-1600-4_LFP.mat')

%% SPECTROGRAM 
Fs = LFP.freq;
window = [-3, 3];
channel = 1;

LPON_dataWindows    = dcMakeDataWindows(LFP, behav, 'LPON',     window, channel);
LPOFF_dataWindows   = dcMakeDataWindows(LFP, behav, 'LPOFF',    window, channel);
ReinON_dataWindows  = dcMakeDataWindows(LFP, behav, 'ReinON',   window, channel);
ReinOFF_dataWindows = dcMakeDataWindows(LFP, behav, 'ReinOFF',  window, channel);

%% MEAN SPECTROGRAMS

dcMeanSpectrogram(ReinON_dataWindows,Fs);

dcMeanSpectrogram(ReinOFF_dataWindows,Fs);
