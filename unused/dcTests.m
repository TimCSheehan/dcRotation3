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
params.Fs = 300; % sampling frequency
params.fpass=[0 100]; % frequencies of interest
%params.tapers=[2 3];
params.tapers=[5 9];
params.trialave=0; % average over trials
params.err=0; % no error computation

[S1,t,f]=mtspecgramc(filtered_notch,movingwin,params);

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

%% spec of white noise

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


%%

Fs = 300;
N = length(y1);
y1_dft = fft(y1);
y1_dft = y1_dft(1:N/2+1);
psd_y1 = (1/(Fs*N)) * abs(y1_dft).^2;
psd_y1(2:end-1) = 2*psd_y1(2:end-1);
freq = 0:Fs/length(y1):Fs/2;

notch_dft = fft(filtered_notch);
notch_dft = notch_dft(1:N/2+1);
psd_notch = (1/(Fs*N)) * abs(notch_dft).^2;
psd_notch(2:end-1) = 2*psd_notch(2:end-1);
freq_notch = 0:Fs/length(filtered_notch):Fs/2;


plot(freq,10*log10(psd_y1))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
hold on
plot(freq_notch,10*log10(psd_notch))

%%


    %EXAMPLE: Decimate a signal by a factor of four
    t = 0:.00025:1;  % Time vector
    x = sin(2*pi*30*t) + sin(2*pi*60*t);
    y = decimate(x,4);
    subplot(1,2,1);
    stem(x(1:120)), axis([0 120 -2 2])   % Original signal
    title('Original Signal')
    subplot(1,2,2);
    stem(y(1:30))                        % Decimated signal
    title('Decimated Signal')

 %%
 
 
    
    
    
    
    
    
    
    
    
    