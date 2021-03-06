function f1 = dcMeanSpectrogram(arrayOfDataWindows, Fs)
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
    %% figure
    f1 = figure;
    a1 = axes;
    p1 = imagesc(wavespec.timestamps, wavespec.freqs, meanps);
    hold on
    p2 = line([0 0], [0 1000], 'Color', 'w');
    a1.YDir = 'normal';
    % a1.YScale = 'log';
    y1 = ylabel('Frequency (Hz)');
    x1 = xlabel('Time (sec)');
end

