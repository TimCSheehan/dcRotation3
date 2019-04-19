% daniela testing stuff

%% stuff for all the bandpass stuffs
            
%            freq_cell = {[1 4], [4 8] , [8 12], [12 30] , [30 50]}
%             for i = 1:length(freq_cell) % for each band
%                 low = freq_cell{i}(1) % this is low
%                 high = freq_cell{i}(2) % this is high
%                 filtered_data = filter(low, high, 'adjasdj')%rthis is you filtering it based on that
%                 if i == 1
%                     frequency_filtered.delta.filtered_data = filtered_data;
%                 elseif i == 2
%                     frequency_filtered.theta.filtered_data = filtered_data;
%                 end  
%             end

%%

freq_cell = {[1 4], [4 8] , [8 12], [12 30] , [30 50]};


for i = 1:length(freq_cell)
    %lowF    = freq_cell{i}(1);
    %highF   = freq_cell{i}(2);
    lowAndHigh = freq_cell{i};
    y   = bandpass(exampleSignal,lowAndHigh,30000);
    y2  = filtfilt(exampleSignal,lowAndHigh);
end

%%
plot(timeVector,exampleSignal)
hold on
plot(timeVector,y)
title('Original vs alpha Signal')

%%
for i = 1:length(freq_cell) % for each band
    low = freq_cell{i}(1) % this is low
    high = freq_cell{i}(2) % this is high
    filtered_data = filter(low, high, 'adjasdj')%rthis is you filtering it based on that
    if i == 1
        frequency_filtered.delta.filtered_data = filtered_data;
    elseif i == 2
        frequency_filtered.theta.filtered_data = filtered_data;
    end  
end

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