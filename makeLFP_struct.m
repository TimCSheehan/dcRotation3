function LFP = makeLFP_struct(nex5struct)
% extract/process LFPs for a session,
% outputs them in struct 'LFP'
% channels ordered 1-16 ascending
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