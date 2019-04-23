%====================================================================>>
% Daniela Cassataro     HW3     COGS260     Signal Processing        >>
%====================================================================>>

import matplotlib
% colors
dcGreenText = 1/255*[68, 170, 68];
dcYellowBox = 1/255*[225, 255, 127];
dcGreenBox = 1/255*[163, 244, 140];
dcTealBox = 1/255*[141, 244, 191];

%====================================================================>>
%                                                           1 ABC    >>
%====================================================================>>

  %%%%%
  % A %
  %%%%%

spikes = load("HW3_simulated_spikes.csv"); % load simulated spikes data

% dt = 0.002; % bin 2 ms
% tFinal = 2; % duration 2 sec

timeVec = spikes(1:end, 1);
numSpikes = spikes(1:end, 2);

plot(timeVec, numSpikes, 'color', dcGreenText)
title("Number of spikes over two seconds")
xlabel("Time (s)")
ylabel("Number of spikes")

  %%%%%
  % B %
  %%%%%
  
corSpikes = xcorr(numSpikes);
