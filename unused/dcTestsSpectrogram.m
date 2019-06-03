%% colors
dcGreen = 1/255*[68, 170, 68];
dcPurple = 1/255*[166, 38, 164];
dcLightGreen = 1/255*[163, 244, 140];
dcRed = 1/255*[224, 17, 73];
dcBlue = 1/255*[66, 185, 255];
%% SPECTROGRAM 
%%
Fs = LFP.freq;
totalCh = length(LFP.channel);
pieceToPlot = [Fs*60*5, Fs*60*40];
%% plot raw stuff
for ch = 1:totalCh
    subplot(totalCh,1,ch) 
    plot(LFP.channel{ch}.data)
    xlim(pieceToPlot)
    %ylabel(ch)
    axis off
    if ch==totalCh
        break
    end
    hold on
end
%% notch filt
LFPn = LFP;
for ch = 1:totalCh
    LFPn.channel{ch}.data = dcNotch60(LFP.channel{ch}.data,Fs);
end
%% plot notched stuff
for ch = 1:totalCh
    subplot(totalCh,1,ch) 
    plot(LFPn.channel{ch}.data)
    xlim(pieceToPlot)
    %ylabel(ch)
    axis off
    if ch==totalCh
        break
    end
    hold on
end
%% notch vs raw time domain
plot(LFP.channel{1}.data)
hold on
plot(LFPn.channel{1}.data)
xlim(pieceToPlot)
axis off

%%
window = [-3, 3];
channel = 1;

LPON_dataWindows    = dcMakeDataWindows(LFP, behav, 'LPON',     window, channel);
LPOFF_dataWindows   = dcMakeDataWindows(LFP, behav, 'LPOFF',    window, channel);
ReinON_dataWindows  = dcMakeDataWindows(LFP, behav, 'ReinON',   window, channel);
ReinOFF_dataWindows = dcMakeDataWindows(LFP, behav, 'ReinOFF',  window, channel);

%% MEAN SPECTROGRAMS

dcMeanSpectrogram(ReinON_dataWindows,Fs);

dcMeanSpectrogram(ReinOFF_dataWindows,Fs);

%%
for row = 1:10 %first 10 lever press onsets
    plot(timeWindow,LPON_dataWindows(row,:))
    hold on
end
%%
for row = 1:58 %first x lever press onsets
    plot(ReinON_dataWindows(row,:))
    hold on
end
%% old
doSpecOnThisSingle = ReinON_dataWindows(1,:);
%% once
[s, f, t, ps] = spectrogram(doSpecOnThisSingle, 128, 120, 128, Fs, 'yaxis');

t_toPlot = window_tbeg:range(window)/(length(t)-1):window_tend;

spg = figure();
a = axes;
imagesc(t_toPlot, f, ps);
a.YScale = 'log';
a.YLim = [1 100];
a.YDir='reverse';
ylabel('Frequency (Hz)')
xlabel('Time (s)')


%% power spec tests
testCh = 5;
%%
signal = LFP.channel{testCh}.data;
signaln = LFPn.channel{testCh}.data;
%fftSignal = fft(signal);
%powerSpectrum = abs(fftSignal).^2;
pSpec{testCh} = pmtm(signal);
pSpecn{testCh} = pmtm(signaln);
%%
%tdomain_pspec = ifft(pSpec{testCh});
%%
freqVec = 0:Fs/(length(pSpec{testCh})-1):Fs;

%%
semilogy(freqVec, pSpec{testCh}, 'color', dcGreen, 'LineWidth',1.5)
xlim([0,1000])
title('Power Spectral Estimate')
ylabel('Power')
xlabel('Frequency')
set(gca, 'FontSize',12)
%%
semilogy(freqVec, pSpec{testCh}, 'color', dcGreen)
hold on
semilogy(freqVec, pSpecn{testCh}, 'color', dcRed)
xlim([0,150])
title('Power Spectral Estimate')
ylabel('Power')
xlabel('Frequency')
set(gca, 'FontSize',12)
%%
plot(freqVec, pSpec{testCh}, 'color', dcGreen)
hold on
plot(freqVec, pSpecn{testCh}, 'color', dcRed)
xlim([0,150])
title('Power Spectral Estimate')
ylabel('Power')
xlabel('Frequency')
set(gca, 'FontSize',12)