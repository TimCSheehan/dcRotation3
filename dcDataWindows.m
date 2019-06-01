function EVENT_dataWindows = dcDataWindows(LFP,behav,EVENT,window)
    window_tbeg = window(1);
    window_tend = window(2);
    %% make window
    Fs = LFP.freq;
    timeStep = 1/Fs;
    tbeg = LFP.tbeg;
    tend = LFP.tend;
    %window_baseline_tend = -2; % end time for baseline window (seconds)
    %% LFP Channel Processing
    LFP_timestamps = tbeg:timeStep:tend;
    %%
    timeWindow = window_tbeg:timeStep:window_tend;
    %% init EVENT data windows array
    totalEVENT = length(behav.(EVENT).ts);
    EVENT_dataWindows=zeros(totalEVENT,length(timeWindow));
    for event_index = 1:totalEVENT
        %find nearest data timestamp to lever press onset timestamp
        LFP_event_idx = nearestpoint(behav.(EVENT).ts(event_index),LFP_timestamps); 
        % create peri-event data window
        % captures the LFP within that window
        dataWindow = LFP.channel{1}.data(LFP_event_idx + (window_tbeg * Fs) : LFP_event_idx + window_tend * Fs)'; 
        %% Store data per event
        EVENT_dataWindows(event_index,:) = dataWindow;
    end
end

