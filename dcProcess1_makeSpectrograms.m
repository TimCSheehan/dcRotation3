% dc Process 1: make spectrograms

%% colors
dcGreen = 1/255*[68, 170, 68];
dcPurple = 1/255*[166, 38, 164];
dcLightGreen = 1/255*[163, 244, 140];
dcRed = 1/255*[224, 17, 73];
dcBlue = 1/255*[66, 185, 255];
%% load LFP and behav mats.
% have to be in the folder you want
dirbehav = dir('*_behavior.mat');
load(dirbehav.name)
dirLFP = dir('*_LFP.mat');
load(dirLFP.name)
%%
%make behav into success and fails
%% set things 
Fs = LFP.freq;
window = [-3, 3];
channel = 1;
%% make data window arrays to feed to spectrogram
%LPON_dataWindows    = dcMakeDataWindows(LFP, behav, 'LPON',     window, channel);
%LPOFF_dataWindows   = dcMakeDataWindows(LFP, behav, 'LPOFF',    window, channel);
ReinON_dataWindows  = dcMakeDataWindows(LFP, behav, 'ReinON',   window, channel);
%ReinOFF_dataWindows = dcMakeDataWindows(LFP, behav, 'ReinOFF',  window, channel);
%% make mean SPECTROGRAMS
%single
dcMeanSpectrogram(LPOFF_dataWindows(254,:),Fs);
%%
dcMeanSpectrogram(ReinON_dataWindows,Fs);
%%
dcMeanSpectrogram(LPOFF_dataWindows,Fs);
%%
loopSpecOnThis = ReinON_dataWindows;
for row = 1:size(loopSpecOnThis,1)
    wf=dcMeanSpectrogram(loopSpecOnThis(row,:),Fs);
    title(row)
    waitfor(wf)
end

%keyboard()
