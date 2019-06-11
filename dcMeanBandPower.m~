function meanBandPower = dcMeanBandPower(arrayOfDataWindows, band, Fs)
%% get average spectrogram
totalSpecs = size(arrayOfDataWindows,1);
%title = "animalid group event" 
% try getting this title somewhere along the

% fix timestamps part, 
% this will fail if the time window is asymmetrical:
timestamps = 0:1/Fs:size(arrayOfDataWindows, 2)/Fs;
timestamps = timestamps - median(timestamps); % to shift the middle to zero

lfp.samplingRate = Fs;
lfp.timestamps = timestamps(1:size(arrayOfDataWindows, 2));

for row = 1:totalSpecs
    lfp.data = arrayOfDataWindows(row,:)';

    wavespec = bz_WaveSpec(lfp);

    ps = abs(wavespec.data').^2;

   if row == 1
       sumps = ps;
   end
   if row > 1
       sumps = sumps+ps;
   end
   if row == totalSpecs
       meanps = sumps/totalSpecs;
   end
end
%% capture only a band
for frequency = 1:wavespec.nfreqs
    if frequency == 1
        meanpsBand = [];
    end
    if wavespec.freqs(frequency) > band(1) && wavespec.freqs(frequency) < band(2)
        meanpsBand = [meanpsBand; meanps(frequency,:)];
    end
end

meanBandPower = mean(meanpsBand);
end

