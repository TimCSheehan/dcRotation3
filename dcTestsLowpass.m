%% daniela testing stuff
%% establish
Fs = 30*1000;
endTime = 4; %sec

%don't change:
timeStep = 1/Fs;
timeVector = 0:timeStep:endTime;

%% make examle signal
exampleSignal = sin(2*pi*18*timeVector)+7*sin(1*pi*6*timeVector)+3*cos(1*pi*2*timeVector)+2*cos(2*pi*500*timeVector);
plot(timeVector,exampleSignal)
%% lowpass filter
lowpassedSignal = filter(dcLowpass,exampleSignal);
plot(timeVector,exampleSignal)
hold on
plot(timeVector,lowpassedSignal)

%%
xLenSignal      = length(exampleSignal);
%xLenLowpassed   = length(lowpassedSignal);

%%
wNoise = wgn(Fs*endTime+1,1,0);

%plot(
%filter(Hd,chop.)