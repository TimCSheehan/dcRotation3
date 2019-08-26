%% MAKE SPECTROGRAMS ---------------------------------------------------//
%   Version 1
%   6/14/2019 Daniela Cassataro
% ----------------------------------------------------------------------//
%   DEPENDENCIES:
%       dcMakeDataWindows.m
%           nearestpoint.m
%       dcMeanSpectrogram.m
%           buzcode
% ----------------------------------------------------------------------//
%   1. For a single session, load in LFP and behavior mats as structs
%
%   2.  
%       
%
%   3. x 
%      x
%
%   4. x
%
%   5. x
% ----------------------------------------------------------------------//
%   NOTES:
%       Currently, the whole process operates on a single session, and 
%       a single channel within that session. (you can set which channel 
%       to use by changing "channel" variable near the top).
% ----------------------------------------------------------------------//
%   THINGS TO IMPROVE:
%     * Ability to compare spectrograms across animals.***
%     * More automated way of saving all spectrograms for all trials.
%     * More automated naming system for saving the spectrograms. Maybe
%       this would go inside the dcMeanSpectrogram func.
%     * Use multiple channels? Wouldn't matter much for only LFP analysis.
%     * 
% ----------------------------------------------------------------------//
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
window = [-3, 3]; %time window. you can only use symmetrical time windows right now
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
%% loop 
loopSpecOnThis = ReinON_dataWindows;
for row = 1:size(loopSpecOnThis,1)
    wf=dcMeanSpectrogram(loopSpecOnThis(row,:),Fs);
    title(row)
    waitfor(wf)
end

%keyboard()
