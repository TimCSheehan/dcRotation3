Fs = 1000;
window = [-3, 3];
%% get average spectrogram
window_tbeg = window(1);
window_tend = window(2);
totalSpecs = size(ReinON_dataWindows,1);
%%
for row = 1:totalSpecs
   [s, f, t, ps] = spectrogram(ReinON_dataWindows(row,:), 128, 120, 128, Fs, 'yaxis');
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
imagesc(t_toPlot, f, meanps)
ylabel('Frequency (Hz)')
xlabel('Time (s)')
a.YScale = 'log';
a.YLim = [1 100];



