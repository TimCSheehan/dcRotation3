function spg = dcMeanSpectrogram(arrayOfDataWindows, Fs, window)
%% get average spectrogram
    window_tbeg = window(1);
    window_tend = window(2);
    totalSpecs = size(arrayOfDataWindows,1);
    %%
    for row = 1:totalSpecs
       [s, f, t, ps] = spectrogram(arrayOfDataWindows(row,:), 128, 120, 128, Fs, 'yaxis');
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
    %%  
    t_toPlot = window_tbeg:range(window)/(length(t)-1):window_tend;

    spg = figure();
    a = axes;
    surf(t_toPlot, f, meanps, 'EdgeColor', 'none');
    ylabel('Frequency (Hz)')
    xlabel('Time (s)')
    a.YScale = 'log';
    a.YLim = [0 100];
    view([0 90])
    axis tight

end

