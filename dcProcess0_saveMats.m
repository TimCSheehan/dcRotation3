%% PRE-PROCESS ---------------------------------------------------------//
%   Version 1
%   5/29/2019 Daniela Cassataro
% ----------------------------------------------------------------------//
%   DEPENDENCIES:
%       makeBehavior_struct.m
%       makeLFP_struct.m
%       readNex5File.m
% ----------------------------------------------------------------------//
%   1. User prompt navigate to a directory of nex5 files.
%
%   2. User prompt navigate to a directory that contains folders for 
%       each session.
%
%   3. User inputs which components they need to extract from nex5 files 
%       ("all", "LFP", "behavior" are currently supported).
%
%   4. Calls functions to make structs for those components
%
%   5. Saves those structs as separate .mat files in the appropriate 
%       session folder. The .mat files will have the same name as the 
%       session name, but with '_LFP.mat' or '_behavior.mat' appended.
% ----------------------------------------------------------------------//
%   NOTES:
%       The slowest part of this code is the line with "readNex5File()"
%       This is the step where the nex5 file is being read using the
%       nexMatlab functions (not written by us.)
% ----------------------------------------------------------------------//
%   THINGS TO IMPROVE:
%     * Add basename as another field in the struct so that they're always
%       identifiable from within. ***
%     * Add "spikes" extraction ability. to do it parallel to the LFP and
%       behavior extractions, write the makeSpikes_struct.m function and
%       add it to the conditional statements in the for loop below.
%     * Make the user prompts for directories more clear about what the 
%       user is supposed to select for each step. Maybe do this by using 
%       a GUI/popup instruction before selecting dir.
%     * In the same vein, make the selection of "components to save" 
%       happen via a button/toggle GUI "all/LFP/behavior/spikes"
% ----------------------------------------------------------------------//
%% choose directories
nex5Dir = uigetdir('F:\Daniela'); %choose directory where the nex5 files are
cd(nex5Dir); % change directory to there
% get the folder, filenames, other info of all files ending in .nex5 
% in the directory you're in. put it in a struct called listOfNexFiles
listOfNexFiles = dir('*.nex5'); 

% choose the directory which CONTAINS the session folders
sessionDir = uigetdir('F:\Daniela');

% set this to extract LFP or behavior or all components from the nex5file
componentsToSave = 'all'; % currently can accept: "all", "LFP", "behavior"

%% loop through each file, aka each mouse's recording session.
for file = 1:length(listOfNexFiles) 
    fullname = listOfNexFiles(file).name; % which .nex5 name you're on
    basename = fullname(1:end-5);
    lfpname  = strcat(basename,'_LFP');
    behavname = strcat(basename,'_behavior');
    
    cd(nex5Dir) % go to nex5 directory
    % Load .nex5 file into a struct using the nex function they built
    % makes everything into datatype: double (we can't really control that)
    nex5struct = readNex5File(fullname); 
    % NOTE:
    % do not edit the nex5struct in any nested functions, or else it 
    % will make a second copy in the workspace. only read from it.
    
    cd(sessionDir) %go to dir where the session folders are
    % if the session doesn't yet have a folder in the chosen session dir,
    if ~exist(basename, 'dir')
       mkdir(basename) % make the session folder.
    end
    cd(basename) % cd to the specific session's folder
    
    % componentsToSave = LFP, behavior, or all
    if strcmpi(componentsToSave,'all')
        LFP = makeLFP_struct(nex5struct);
        save(lfpname, 'LFP','-v7.3'); % save LFP struct in your current directory
        
        behav = makeBehavior_struct(nex5struct);
        save(behavname, 'behav','-v7.3'); % save behav struct in your current directory
    end
    if strcmpi(componentsToSave,'LFP')
        LFP = makeLFP_struct(nex5struct);
        save(lfpname, 'LFP','-v7.3');
    end
    if strcmpi(componentsToSave,'behavior')
        behav = makeBehavior_struct(nex5struct);
        save(behavname, 'behav','-v7.3'); 
    end
    
    clear nex5struct

end