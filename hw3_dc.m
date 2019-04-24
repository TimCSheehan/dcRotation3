%====================================================================>>
% Daniela Cassataro     HW3     COGS260     Signal Processing        >>
%====================================================================>>

% colors
dcGreenText = 1/255*[68, 170, 68];
dcYellowBox = 1/255*[225, 255, 127];
dcGreenBox = 1/255*[163, 244, 140];
dcTealBox = 1/255*[141, 244, 191];

%====================================================================>>
%                                                           1 ABC    >>
%====================================================================>>
%% 1
  %%%%%   Download the simulated dataset, HW3_simulated_spikes.csv. 
  % A %   The first column contains the time, in seconds. The second 
  %%%%%   column contains the number of spikes recorded during that time 
  %%%%%   bin. The recording is 2 s in duration, and sampled at dt = 2 ms. 
  %%%%%   Load the data and make a plot showing number of spikes vs. time.

spikes = load("HW3_simulated_spikes.csv"); % load simulated spikes data

timeVec = spikes(1:end, 1);
numSpikes = spikes(1:end, 2);

figure(1)
plot(timeVec, numSpikes, 'color', dcGreenText)
title("Number of spikes over two seconds")
xlabel("Time (s)")
ylabel("Number of spikes")
%% 1
  %%%%%   Calculate the autocorrelation function of the spike trains.
  % B %   Plot the correlation vs. lag for lags ranging from -1 to 1 s.
  %%%%%   Comment on the result.
  
[corSpikes,lags] = xcorr(numSpikes);
[maxCor, indexMiddle] = max(corSpikes,[],'linear');

figure(2)
bar(lags,corSpikes,'k')
title("Autocorrelation of spike times within two-second window")
xlabel("Time lag (ms)")
ylabel("Number of spikes")

% There is a rhythmic component to the spike train at ~12 Hz!

%% 1
  %%%%%   You may notice that the autocorrelation declines toward the  
  % C %   edges of the time window, due to the fact that we only have 2 s 
  %%%%%   of data. This reflects the bias of our estimate of the 
  %%%%%   correlation. Compute the unbiased autocorrelation and comment 
  %%%%%   on the similarities/differences from the biased autocorrelation.


[corSpikesUnb,lagsUnb] = xcorr(numSpikes,'unbiased');

figure(3)
bar(lagsUnb,corSpikesUnb,'k')
title("Unbiased autocorrelation of spike times within two-second window")
xlabel("Time lag (ms)")
ylabel("Number of spikes")

%====================================================================>>
%                                                      3 ABCDE G     >>
%====================================================================>>

%% 3
  %%%%%   Simulate a signal which is the sum of two sinusoidal 
  % A %   oscillations at frequencies 2 Hz and 2.3 Hz with amplitudes
  %%%%%   1 �V and 1.5 �V, respectively. Choose the duration of the
  %%%%%   signal T=60 s and the sampling rate Fs=10 Hz. Plot the signal,
  %%%%%   and zoom in on the first 30 s. 

T = 60; %duration 60 s
Fs = 10; %sampling rate 10 Hz
simTimeVec = 0:1/Fs:60;

simSignal = sin(2*pi*2*simTimeVec) + 1.5*sin(2*pi*2.3*simTimeVec);

figure(4)
plot(simTimeVec,simSignal,'color',dcGreenText)
xlim([0,30])
title("Sum of sines signal")
xlabel("Time (s)")
ylabel("Amplitude (uV)")

%% 3
  %%%%%   Estimate the RMS of the signal by calculating
  % B %   the standard deviation of your sampled signal.
  %%%%%

sigRMS = std(simSignal);
disp('RMS of signal = ')
disp(sigRMS)

%% 3
  %%%%%   What should the noise RMS be to give a signal-to-noise  
  % C %   ratio (SNR) of 10 db? Use the result of the previous  
  %%%%%   question and the formula for SNR (Eq. 3.13 in the book).

%SNR = 10*log_10(sigRMS/noiseRMS)
%10  = 10*log_10(1.2748/noiseRMS)
%10^1 = 1.2748/noiseRMS

% for an SNR of 10 dB:
noiseRMS = sigRMS/10;
disp('RMS of noise = ')
disp(noiseRMS)

%% 3
  %%%%%   Now add Gaussian white noise to the signal. Choose the amplitude
  % D %   of the noise so that the SNR is 10 dB. Plot the signal + noise.
  %%%%%   

noise = randn(1,601) * noiseRMS ;

ns = noise + simSignal;

figure(5)
plot(simTimeVec, ns)
xlim([0,30])
title("Noisy sum of sines signal")
xlabel("Time (s)")
ylabel("Amplitude (uV)")
  
%% 3
  %%%%%   Compute the Fourier transform of the signal+noise and take its    
  % E %   absolute value squared to estimate the power spectrum of the  
  %%%%%   signal+noise. This is the periodogram estimate of the spectral
  %%%%%   power, P(w). What are the units for P(w)?

fftns = fft(ns);

powerSpec = abs(fftns).^2;

f = (0:(length(powerSpec)-1))./(length(powerSpec)-1) ;
freqVec = Fs.*f; %get frequency axis


figure(6)
semilogy(freqVec,powerSpec,'color',dcGreenText,'LineWidth',1.5)
title("Periodogram")
xlabel("Frequency (Hz)")
ylabel("Power ()")

%% 3
  %%%%%   Now use Welch?s method to estimate the power spectrum using 
  % G %   non-overlapping chunks of data of duration Tchunk=10 s. Again, 
  %%%%%   plot the power spectrum for both the signal and the signal+noise.

[sigWelch,fWelch] = pwelch(simSignal, 100, 0,freqVec,Fs);

nsWelch  = pwelch(ns,100,0,freqVec,Fs);

figure(7)
subplot(2,1,1);
plot(fWelch,sigWelch,'color','k','LineWidth',2)
title("Welch's estimate of power spectrum, pure signal")
ylabel("Power ()")

subplot(2,1,2);
plot(fWelch,nsWelch,'color',dcGreenText,'LineWidth',2)
title("Welch's estimate of power spectrum, noisy signal")
xlabel("Frequency (Hz)")
ylabel("Power ()")


