function Behav = makeBehavior_struct(nex5struct)
% extract/process behavior timestamps for a session,
% outputs them in struct 'Behav'
    %% Event timestamp extraction
    % make new vecs of timestamps of each type of event. 
    % pull from where they're already stored, in nex5FileData.events
    % (where each row is an event type struct of timestamps)
    LP_OFF      = nex5struct.events{1}.timestamps;      % leverpress off
    LP_ON       = nex5struct.events{2}.timestamps;      % leverpress on
    REIN_OFF    = nex5struct.events{3}.timestamps;      % reinforcer off
    REIN_ON     = nex5struct.events{4}.timestamps;      % reinforcer on
    SESS_OFF    = max(nex5struct.events{5}.timestamps); % Session end 
    SESS_ON     = min(nex5struct.events{6}.timestamps); % Session start 
    %% Remove leverpresses occuring outside session start--end
    % (t = "true" press)
    t_LP_OFF = LP_OFF(LP_OFF > SESS_ON);
    t_LP_OFF = t_LP_OFF(t_LP_OFF < SESS_OFF);

    t_LP_ON = LP_ON(LP_ON > SESS_ON);
    t_LP_ON = t_LP_ON(t_LP_ON < SESS_OFF);
    
    t_LP_ON = t_LP_ON(1:end-1); % [DC] why do we cut this out?
    %% Remove lever press onset and offset that don't follow each other
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
    %% Add fields to the Behav struct
    Behav.SessionStart             = SESS_ON; 
    Behav.SessionEnd               = SESS_OFF;
    
    Behav.ReinON.ts                = REIN_ON; % timestamps reinforcement ON
    Behav.ReinON.Event_Label       = 'Reinforcement Onset';
    Behav.ReinOFF.ts               = REIN_OFF; % timestamps reinforcement OFF
    Behav.ReinOFF.Event_Label      = 'Reinforcement Offset';   
    
    Behav.LPOFF.ts                 = t_LP_OFF; % timestamps LP OFF
    Behav.LPOFF.Event_Label        = 'Lever Press Offset';
    Behav.LPON.ts                  = t_LP_ON; % timestamps LP ON
    Behav.LPON.Event_Label         = 'Lever Press Onset';   
    
    Behav.LeverPress_Durations     = LP_DUR;
    Behav.TotalReinforcersEarned   = length(REIN_ON);
end