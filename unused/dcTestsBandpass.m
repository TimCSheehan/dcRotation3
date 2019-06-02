%% daniela testing stuff
%% establish stuff
Fs = 250;
endTime = 20; %sec

%don't change:
timeStep = 1/Fs;
timeVector = 0:timeStep:endTime-timeStep;

%% chop
load('chop.mat') % 1200 sec long
%%
chopOriginal = chop(1:endTime*Fs);
%%
% delta, theta, alpha, beta, low gamma
freqCell = {[1 4], [4 8] , [8 12], [12 30] , [30 50]};


for i = 1:length(freqCell)
    lowAndHigh = freqCell{i};
    y = bandpass(exampleSignal,lowAndHigh,downFs);
    
    if i == 1
        frequency_filtered.delta.filtered_data = y;
    elseif i == 2
        frequency_filtered.theta.filtered_data = filtered_data;
    end 
end
%% delta
chopDelta   = bandpass(chopOriginal,[1, 4],Fs);
%%
chopTheta   = bandpass(chopOriginal,[4, 8],Fs);

%%
chopAlpha   = bandpass(chopOriginal,[8, 12],Fs);
%%
chopBeta    = bandpass(chopOriginal,[12, 30],Fs);
%%
chopGamma   = bandpass(chopOriginal,[30,50],Fs);

%% CHOPPED actual data

plot(timeVector,chopOriginal)
hold on
plot(timeVector,chopDelta)
hold on
plot(timeVector,chopTheta)
hold on
plot(timeVector,chopAlpha)
hold on
plot(timeVector,chopBeta)
hold on
plot(timeVector,chopGamma)
legend('original','delta','theta','alpha','beta','gamma')
title('Original sig vs bandpass')



%% example
exampleSignal = sin(2*pi*18*timeVector)+5*cos(1*pi*2*timeVector);
%plot(timeVector,exampleSignal)
y   = bandpass(exampleSignal,[1, 4],Fs);
%% example
plot(timeVector,exampleSignal)
hold on
plot(timeVector,y)
title('Original vs delta Signal')
%%
% for i = 1:length(freq_cell) % for each band
%     low = freq_cell{i}(1) % this is low
%     high = freq_cell{i}(2) % this is high
%     filtered_data = filter(low, high, 'adjasdj')%rthis is you filtering it based on that
%     if i == 1
%         frequency_filtered.delta.filtered_data = filtered_data;
%     elseif i == 2
%         frequency_filtered.theta.filtered_data = filtered_data;
%     end  
% end

