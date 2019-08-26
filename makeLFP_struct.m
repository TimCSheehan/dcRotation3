function LFP = makeLFP_struct(nex5struct)
%% MAKE LFP STRUCT ------------------------------------------------//
%   Version 1
%   6/14/2019 Daniela Cassataro
% ----------------------------------------------------------------------//
%   DEPENDENCIES:
%       dcLowpass300.m
% ----------------------------------------------------------------------//
%   INPUT:
%       a single matlab struct 
%       (which has been read into your workspace from a nex5 file)
% ----------------------------------------------------------------------//
%   OUTPUT:
%       a single matlab struct containing the lowpassed, downsampled LFP
%       traces for 16 digital channels, in ascending order, over the whole
%       behavior session.
% ----------------------------------------------------------------------//
%   1. Extract LFP one channel at a time.
%
%   2. Low-pass filter (currently set to use 'dcLowpass' at 300Hz)
%
%   3. Downsample (currently set to 1000 Hz. with resample, there's some 
%       more antialiasing done here so it's not just taking every few 
%       points and throwing away the rest. Could change this if you 
%       wanted something different)
%
%   3. Populate a struct containing the lowpassed, downsampled LFPs by 
%       channel in ascending order.
% ----------------------------------------------------------------------//
%   NOTES:
%       These are just the filters I chose, but you can adjust them to be
%       ones you want. The lowpass one is a custom one I built using
%       filterDesigner. Just type "filterDesigner" in the command window.
%       The filter specs are inside dcLowpass300.m, which should not be
%       altered. You can also view the filter by typing "filterDesigner,"
%       opening the tool, and the clicking 'open-> dcLowpass300.fda'. This
%       filter assumes a 30kHz sampling rate, and is very specific to this
%       data, so I would be careful generalizing it.
% ----------------------------------------------------------------------//
%   THINGS TO IMPROVE:
%     * If there's something important you want from the analog channels,
%       pull it out here, too.
%     * If you wanted to use a more generalizable filter, replace
%       'dcLowpass300.m' with your desired filt.
% ----------------------------------------------------------------------//
    %% vars
    Fs = nex5struct.freq;
    Fs_downsampled = 1*1000; % Hz
    %% for each channel with LFPs
    for channel = 12:length(nex5struct.contvars) % for each LFP channel (skip the ADC and AUX channels)
        % get the real number of the channel from the 'name' field
        channelNumberForOrdering = str2num(nex5struct.contvars{channel}.name(3:end));
        chLFP = nex5struct.contvars{channel}.data; %extracts channel LFP
        %do the low pass filt
        % maybe change this filt to include Fs and another var for lowpass
        chLFP_filtered = filter(dcLowpass, chLFP); 
        %do the downsamp
        %     Y = resample(X,P,Q) resamples the values, X, of a uniformly sampled
        %     signal at P/Q times the original sample rate using a polyphase
        %     anti-aliasing filter. 
        chLFP_downsampled = resample(chLFP_filtered, 1, Fs/Fs_downsampled);
        %add this downsampled channel to the new struct
        % change the naming depending on christian's pref.
        % i think it should go from 1-16 but idk the order.
        LFP.channel{channelNumberForOrdering}.data = chLFP_downsampled;
        % channel name kept as a string
        LFP.channel{channelNumberForOrdering}.name = nex5struct.contvars{channel}.name; 
    end
    LFP.freq = Fs_downsampled;
    LFP.tbeg = nex5struct.tbeg;
    LFP.tend = nex5struct.tend;
end