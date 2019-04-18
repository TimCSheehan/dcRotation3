% daniela testing stuff
%% NOTE: you should use the kind with 'fir' as a third argument
% on ANYTHING large/requiring >13 downsample factor
% you can also do it in stages, 
% decY = decimate(y,5,'fir'), decimate that again, etc
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