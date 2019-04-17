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
Fs = 30*1000;
endTime = 2; %sec

%don't change:
timeStep = 1/Fs;
timeVector = 0:timeStep:endTime-timeStep;
wNoise = wgn(Fs*endTime,1,0);
%%
exampleSignal = sin(2*pi*12*timeVector)+cos(1*pi*7*timeVector);
plot(timeVector,exampleSignal)

%%
% decimate to 250 samples/sec
downedFs = 250; %250 samples/sec, change to whatever you want to downsample to
downFactor = Fs/downedFs; %the factor to downsample BY...
%%
downedSignal = decimate(exampleSignal,downFactor);
%%

xLenSig = length(exampleSignal);
xLenDowned = length(downedSignal);
%%
subplot(1,2,1);
stem(exampleSignal(1:xLenSig), axis([0 xLenSig, 0 2])   % Original signal
title('Original Signal')
subplot(1,2,2);
stem(downedSignal(1:xLegDowned)                        % Decimated signal
title('Decimated Signal')