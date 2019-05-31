%% daniela pre-process 5/29/2019
%% choose directories
nex5Dir = uigetdir('F:\Daniela'); %choose directory where the nex5 files are
cd(nex5Dir); % change directory to there
% get the folder, filenames, other info of all files ending in .nex5 
% in the directory you're in. put it in a struct called listOfNexFiles
listOfNexFiles = dir('*.nex5'); 

% choose the directory which CONTAINS the session folders
sessionDir = uigetdir('F:\Daniela');

% set this to extract LFP or behavior or all components from the nex5file
componentsToSave = 'all';

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