%% colors
dcGreen = 1/255*[68, 170, 68];
dcPurple = 1/255*[166, 38, 164];
dcLightGreen = 1/255*[163, 244, 140];
dcRed = 1/255*[224, 17, 73];
dcBlue = 1/255*[66, 185, 255];
%%
Fs = LFP.freq;
powerSpectrum=[];
%%

signal = LFP.channel{5}.data;
%fftSignal = fft(signal);
%powerSpectrum = abs(fftSignal).^2;
powerSpectrum{5} = pmtm(signal);


%%
freqVec = 0:Fs/(length(powerSpectrum)-1):Fs;

%%
semilogy(freqVec, powerSpectrum, 'color', dcGreen)
xlim([0,1000])
title('Power Spectral Estimate')
ylabel('Power')
xlabel('Frequency')
set(gca, 'FontSize',12)
%%
semilogy(freqVec, powerSpectrum, 'color', dcGreen)
xlim([0,120])
title('Power Spectral Estimate')
ylabel('Power')
xlabel('Frequency')
set(gca, 'FontSize',12)