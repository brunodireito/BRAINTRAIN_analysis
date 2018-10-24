%% BRAINVOYAGER VOI combination
% Script combines VOI in individual files into a single VOI file 
% Requires neuroelf

% Version 1.0
% - Overall restructure

% Author: Bruno Direito (2018)


%% Configuration

% Clear previous data
clear, clc;

% Add folders to path
addpath('utils');
addpath('data');
addpath('helpers');

% Settings Structure
configs = struct();

%% Initalization and VOI data selection

% Set data folder
datafolder = 'T:\DATA_ClinicalTrial';
addpath(datafolder);

configs.dataRoot = fullfile(datafolder, 'ANALYSIS', 'VOI-data');    

% Select files
files = dir( fullfile (configs.dataRoot, 'NF*.voi') );

% create the color palete 
configs.colors = parula( numel(files) );

%% Create new VOI files

% file i/o
% create file
voifilename = sprintf( 'VOI_N_%i.voi', numel(files) );
fileID = fopen(voifilename,'w');

% write header
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
fprintf( fileID, 'NrOfVOIs:                   %i\n\n', numel(files) );

% write each VOI
% iterate VOIs
for i = 1:numel( files )
    
    % voiFile 
    % open file (p.s. Requires neuroelf)
    filepath = fullfile ( configs.dataRoot, files(i).name );
    % debug info
    fprintf('editing voi %s \n', filepath)
    voiFile = xff( filepath );
    % read voiFile
    nrOfVoxels = voiFile.VOI.NrOfVoxels;
    voxels = voiFile.VOI.Voxels;
    
    % write VOI data
    % VOI name - SubjectVOINamingConvention: <VOI>_<SUBJ>
    fprintf( fileID, 'NameOfVOI: %s \n', getTokenSessSubj(files(i).name) );
    % color of VOI
    fprintf( fileID, 'ColorOfVOI: %s \n\n', num2str(round (configs.colors(i,:) * 255 )));
    % nr of voxels
    fprintf( fileID, 'NrOfVoxels: %i \n', nrOfVoxels);
    % write voxel data
    for v = 1:nrOfVoxels
        fprintf( fileID, '%s \n', num2str(voxels(v,:) ) );
    end 
    % write empty lines
    fprintf( fileID, '\n\n');
end

% close file
fclose(fileID);
fprintf('%s file closed.\n', voifilename )
