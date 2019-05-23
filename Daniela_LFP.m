%------------------------------------------------------------------------
% extract LFPs from a session.
% outputs a struct, "Session" with peri-event LFP, 
% theta power around each lever press
%------------------------------------------------------------------------

tic %counts time to run script
selpath = uigetdir('F:\Daniela'); %choose directory where the nex5 files are
cd(selpath); % change directory to there

% get the folder, filenames, other info of all files ending in .nex5 
% in the directory you're in. put it in a struct called listOfNexFiles
listOfNexFiles = dir('*.nex5'); 

%% loop through each file, aka each mouse's recording session.

for file = 1:length(listOfNexFiles) 
    
    % Load .nex5 file into a struct using the nex function they built
    % makes everything into datatype: double (we can't really control that)
    % take the name of a file and pass it into readNex5File:
    nex5FileData = readNex5File(listOfNexFiles(file).name);
    % filename without extension:
    Session.Name = listOfNexFiles(file).name(1:end-5); 
    status = ['Starting  ' Session.Name]; % Indicates what file you're working with
    
    %% Event timestamp extraction
    % make new vecs of timestamps of each type of event. 
    % pull from where they're already stored, in nex5FileData.events
    % (where each row is an event type struct of timestamps)
    LP_OFF = nex5FileData.events{1}.timestamps;     % leverpress off
    LP_ON = nex5FileData.events{2}.timestamps;      % leverpress on
    REIN_OFF = nex5FileData.events{3}.timestamps;   % reinforcer off
    REIN_ON = nex5FileData.events{4}.timestamps;    % reinforcer on
    SESS_OFF = max(nex5FileData.events{5}.timestamps);  % Session end 
    SESS_ON = min(nex5FileData.events{6}.timestamps);   % Session start 
    
    % Remove leverpresses occuring outside session start--end
    % (t = "true" press)
    t_LP_OFF = LP_OFF(LP_OFF > SESS_ON);
    t_LP_OFF = t_LP_OFF(t_LP_OFF < SESS_OFF);

    t_LP_ON = LP_ON(LP_ON > SESS_ON);
    t_LP_ON = t_LP_ON(t_LP_ON < SESS_OFF);
    
    t_LP_ON = t_LP_ON(1:end-1); % [DC] why do we cut this out?
    
    % Remove lever press onset and offset that don't follow each other
    % (e.g. Offsets occuring before Onsets)
    if ~(length(t_LP_OFF) == length(t_LP_ON))
        if length(t_LP_OFF) > length(t_LP_ON)
            t_LP_OFF = t_LP_OFF(1:end-2);
        end
        if length(t_LP_OFF) < length(t_LP_ON)
            t_LP_ON = t_LP_ON(1:end-1);
        end
    end
    %Get Lever Press Lengths by subtraction and remove LPs with <100 ms IPI
    LP_DUR = t_LP_OFF - t_LP_ON;
    t_LP_ON = t_LP_ON(LP_DUR > 0.1);
    t_LP_OFF = t_LP_OFF(LP_DUR > 0.1);
    LP_DUR = t_LP_OFF - t_LP_ON;
    
    
    %% Add new fields to the Session struct so you can analyze...
    Session.Events.SessionStart             = SESS_ON; 
    Session.Events.SessionEnd               = SESS_OFF;
    
    Session.Events.ReinON.ts                = REIN_ON; % timestamps reinforcement ON
    Session.Events.ReinON.Event_Label       = 'Reinforcement Onset';
    Session.Events.ReinOFF.ts               = REIN_OFF; % timestamps reinforcement OFF
    Session.Events.ReinOFF.Event_Label      = 'Reinforcement Offset';   
    
    Session.Events.LPOFF.ts                 = t_LP_OFF; % timestamps LP OFF
    Session.Events.LPOFF.Event_Label        = 'Lever Press Offset';
    Session.Events.LPON.ts                  = t_LP_ON; % timestamps LP ON
    Session.Events.LPON.Event_Label         = 'Lever Press Onset';   
    
    Session.Events.LeverPress_Durations     = LP_DUR;
    Session.Events.TotalReinforcersEarned   = length(REIN_ON);
    
    Session.base_time_start     = -5; % start time for baseline and data window (seconds)
    Session.base_time_end       = -2; % end time for baseline window (seconds)
    Session.post_event_time     = 5; % end time for data window (seconds)
    
    
    %% LFP Channel Processing
    Fs = nex5FileData.freq; % Sampling frequency (Hz)
    timeStep = 1/Fs;
    tbeg = nex5FileData.tbeg;
    tend = nex5FileData.tend;
    LFP_timestamps = tbeg:timeStep:tend;
    time_window = Session.base_time_start:1/Fs:Session.post_event_time;
    
    %% for each channel tho
    for channel = 12:length(nex5FileData.contvars) % for each LFP channel (skip the ADC and AUX channels)
        
        LFP_Data = nex5FileData.contvars{channel}.data; %extracts channel LFP
        
        %% Notch Filter
        wo = 60/(Fs/2);
        bw = wo/35;
        [num,den]=iirnotch(wo,bw); % notch filter implementation 
        notched_LFP_Data = filter(num,den,LFP_Data);
        
        %% Bandpass filter
        [b, a] = butter(2, [.5 250]/(Fs/2)); % Create butterworth Filter (.5 - 250 Hz)
        buttered_LFP_Data = filter(b, a, notched_LFP_Data); % butterworth filtered data
        
        
        %% downsample 
        % dc try: downsample right away, to 1kHz
        % dc try: don't use decimate, take an average of the nearest
        % datapoints when you choose the "every 30" 
        
        downFs = 250; %freq to downsample to
        downFactor = Fs/downFs; %factor to downsample by, sampling freq/goal freq
        downTimeStep = 1/downFs;
        down_LFP_timestamps = tbeg:downTimeStep:tend;
        downsampled_LFP_Data = decimate(buttered_LFP_Data, downFactor, 'fir');
        
        %% for testing, remove later
%        choppedData = downsampled_LFP_Data(1:10*250);
        
%         %% test plots, remove later
%         TEST_Fs = 30*1000;
%         TEST_downFs = 250;
%         TEST_endTime = 0.2; %sec
% 
%         %don't change:
%         TEST_timeStep = 1/Fs;
%         TEST_timeVector = 0:TEST_timeStep:TEST_endTime;
%         TEST_yStop = (TEST_endTime*TEST_Fs) + 1 ;        
%         TEST_downTimeStep = 1/TEST_downFs;
%         TEST_downTimeVector = 0:TEST_downTimeStep:TEST_endTime;
%         TEST_downYStop = (TEST_endTime*TEST_downFs) +1;
% 
%         plot(TEST_timeVector, LFP_Data(1:TEST_yStop))
%         hold on
%         plot(TEST_timeVector, notched_LFP_Data(1:TEST_yStop))
%         hold on
%         plot(TEST_timeVector, buttered_LFP_Data(1:TEST_yStop))
%         hold on
%         plot(TEST_downTimeVector, downsampled_LFP_Data(1:TEST_downYStop))
            
        %% Create Peri-event data windows (in this case, lever press onset)
        for event_index = 1:length(Session.Events.LPON.ts)
            %find nearest data timestamp to lever press onset timestamp
            Closest_event_idx = nearestpoint(Session.Events.LPON.ts(event_index),down_LFP_timestamps); 
            
            % create peri-event data window
            % captures the LFP within that window??
            % here it's 5 seconds before and after event
            data_window = downsampled_LFP_Data(Closest_event_idx + Session.base_time_start * downFs : Closest_event_idx + Session.post_event_time * downFs)'; 
            
            %% Bandpass Filter (CC made this)
%             filter_range = [4 10]; % Bandpass filter range (e.g. theta 4-10 Hz)
%             theta_filtered = eegfilt(data_window,Fs,filter_range(1),filter_range(2)); %Filter in the theta range
%             theta_power = abs(hilbert(eegfilt(data_window,Fs,filter_range(1),filter_range(2))')').^2; %Calculate theta power
            
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

            
            %% Store data per event
            Session.Events.LPON.data_window{event_index} = data_window;
            Session.Events.LPON.theta_filtered{event_index} = theta_filtered;
            Session.Events.LPON.theta_power{event_index} = theta_power;
        end
        
    end
    % Save session
    save(Session.Name, 'Session', '-v7.3');

end
toc %counts time to run script

% % Sumperipose filtered over raw
% figure
% hold on
% % Plot raw
% subplot(3,1,1)
% plot(time_window, data_window)
% xlabel('Time (ms)')
% ylabel('Voltage (mV)')
% title('Raw')
% % Plot Theta Filtered
% subplot(3,1,2)
% plot(time_window, theta_filtered)
% xlabel('Time (ms)')
% ylabel('Voltage (mV)')
% title('Theta Filtered')
% % Plot Theta Power
% subplot(3,1,3)
% plot(time_window, log(theta_power));
% xlabel('Time (ms)')
% ylabel('Theta Power (log)')
% title('Theta Power')
% hold off
