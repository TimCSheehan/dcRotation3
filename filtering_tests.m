y1 = wgn(1000,1,0);
var(y1)
plot(y1)
%%
wo = 60/(300/2);
bw = wo/35;

[d,c] = iirnotch(wo,bw);
%fvtool(d,c);
%%

filtered_notch = filter(d, c, y1);

%%

plot(y1);
hold on
plot(filtered_notch);

%% Spectogram
movingwin=[0.50 0.025];
params.Fs = 30000; % sampling frequency
params.fpass=[0 100]; % frequencies of interest
%params.tapers=[2 3];
params.tapers=[5 9];
params.trialave=0; % average over trials
params.err=0; % no error computation

[S1,t,f]=mtspecgramc(y1,movingwin,params);

figure()
hold on
plot_matrix(S1,t,f);

for i = 1:2
    xline =  min(t);
    line([xline xline],[0 100], 'Color', 'r');
    xline =  3;
    line([xline xline],[0 100], 'Color', 'k');
end

ylim([params(1).fpass])
xlim([min(t) max(t)])
title(sprintf('LFP Spectogram (%s)', LED_state))
xlabel('Time (sec)'); % plot spectrogram
ylabel('Frequency (Hz)');
caxis([-29 29]); cbar = colorbar;
colormap jet
cbar.Label.String = {'Power (dB)'};