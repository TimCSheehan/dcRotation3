%%
% %EXAMPLE: Decimate a signal by a factor of four
% t = 0:.00025:1;  % Time vector
% x = sin(2*pi*30*t) + sin(2*pi*60*t);
% y = decimate(x,4);
% 
% subplot(1,2,1);
% stem(x(1:120)), axis([0 120 -2 2])   % Original signal
% title('Original Signal')
% subplot(1,2,2);
% stem(y(1:30))                        % Decimated signal
% title('Decimated Signal')

% daniela testing stuff
%% NOTE: you should use the kind with 'fir' as a third argument
% on ANYTHING large/requiring >13 downsample factor
% you can also do it in stages, 
% decY = decimate(y,5,'fir'), decimate that again, etc
%%

Fs = 30*1000;
endTime = 4; %sec

%don't change:
timeStep = 1/Fs;
timeVector = 0:timeStep:endTime;
wNoise = wgn(Fs*endTime,1,0);
%%
exampleSignal = sin(2*pi*18*timeVector)+5*cos(1*pi*2*timeVector);
plot(timeVector,exampleSignal)

%%
% decimate to 250 samples/sec
downedFs = 40; %250 samples/sec, change to whatever you want to downsample to
downFactor = Fs/downedFs; %the factor to downsample BY...
%%
downedSignal = decimate(exampleSignal,downFactor);

%don't change
downedTimeStep = 1/downedFs;
downedTimeVector = 0:downedTimeStep:endTime;
%%

xLenSig = length(exampleSignal);
xLenDowned = length(downedSignal);
%%
plot(timeVector,exampleSignal)
hold on
plot(downedTimeVector,downedSignal)
title('Original vs Decimated Signal')