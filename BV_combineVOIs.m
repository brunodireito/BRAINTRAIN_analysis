%%% ============= BRAIN VOYAGER SCRIPT ============= %%%
%%% ====== BrainTrain Analysis MultiSubject ======== %%%
%%% ================================================ %%%

%% Configuration
clear, clc;

% Add folders to path
addpath('utils');
addpath('data');
addpath('functions');

% Settings Structure
configs = struct();

% Add data folder
datafolder = 'T:\DATA_ClinicalTrial';

addpath(datafolder);
configs.dataRoot = fullfile(datafolder);

% % Initialize COM
% configs.bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');

%% Initalization and Subject Selection
load('Configs_ClinicalTrial.mat');

% Default Patient Name and Folder Name to import .vmr file
subjectname = datasetConfigs.subjects{1};
configs.filesSignature = subjectname;
configs.subjectName = subjectname;

configs.dataRootSubject = fullfile(configs.dataRoot, configs.subjectName);
configs.dataRootAnalyses = fullfile(configs.dataRoot, 'ANALYSIS');
configs.dataRootVOI = fullfile(configs.dataRootAnalyses, 'VOI-data');

configs.colors = copper(75);



%%

% file i/o
fileID = fopen('AllVOI.voi','w');

fprintf( fileID, 'FileVersion: 4 \n\n' );
fprintf( fileID, 'ReferenceSpace: TAL \n\n' );
fprintf( fileID, 'OriginalVMRResolutionX:     1\n' );
fprintf( fileID, 'OriginalVMRResolutionY:     1\n' );
fprintf( fileID, 'OriginalVMRResolutionZ:     1\n' );
fprintf( fileID, 'OriginalVMROffsetX:         0\n' );
fprintf( fileID, 'OriginalVMROffsetY:         0\n' );
fprintf( fileID, 'OriginalVMROffsetZ:         0\n' );
fprintf( fileID, 'OriginalVMRFramingCubeDim:  256\n\n' );
fprintf( fileID, 'LeftRightConvention:        1\n\n' );
fprintf( fileID, 'SubjectVOINamingConvention: <VOI>_<SUBJ>\n\n\n' );
fprintf( fileID, 'NrOfVOIs:                   75\n\n' );

files = dir('T:\DATA_ClinicalTrial\ANALYSIS\VOI-data\*.voi');

for i = 1:numel( files )
    
    % VOI name - SubjectVOINamingConvention: <VOI>_<SUBJ>
    fprintf( fileID, 'NameOfVOI: %s \n', getTokenSessSubj(files(i).name) );
    % Color of VOI
    fprintf( fileID, 'ColorOfVOI: %s \n\n',num2str(round (configs.colors(i,:) * 255 )));
    
    % Read files % TODO
    voiFile = xff( fullfile ( configs.dataRootVOI, files(i).name ) );
    
    nrOfVoxels = voiFile.VOI.NrOfVoxels;
    voxels = voiFile.VOI.Voxels;
    
    % Nr of voxels
    fprintf( fileID, 'NrOfVoxels: %i \n', nrOfVoxels);
    
    % print voxels
    for v = 1:nrOfVoxels
        
        fprintf( fileID, '%s \n', num2str(voxels(v,:) ));
    end
    
    
    % end VOI printf
    fprintf( fileID, '\n\n');
    
    
    
end

fclose(fileID);


