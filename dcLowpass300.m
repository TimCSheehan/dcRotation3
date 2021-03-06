function Hd = dcLowpass300
%DCLOWPASS Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.6 and DSP System Toolbox 9.8.
% Generated on: 28-May-2019 22:56:11

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 30000;  % Sampling Frequency

N    = 300;      % Order
Fc   = 300;      % Cutoff Frequency
flag = 'scale';  % Sampling Flag

% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
Hd = dfilt.dffir(b);

% [EOF]
