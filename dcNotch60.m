function notched = dcNotch60(LFP,Fs)
% Notch Filter for 60Hz
    wo = 60/(Fs/2);
    bw = wo/35;
    [num,den]=iirnotch(wo,bw); % notch filter implementation 
    notched = filter(num,den,LFP);
end

