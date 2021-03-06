function [ fmrProject ] = preprocessFmrProject( configs, fmrProjectNamePath, sliceVector )
%preprocessFmrProject Summary of this function goes here
%   Detailed explanation goes here


%% open FmrProject
runName = strsplit(fmrProjectNamePath,'-');
fmrProjectName = fullfile( configs.dataRootSubject, fmrProjectNamePath, 'PROJECT', 'PROCESSING', [ configs.filesSignature '_' runName{2} '.fmr']);

fmrProject = configs.bvqx.OpenDocument( fmrProjectName );

fprintf('Preprocessing %s run... \n',runName{2});

%% -------------------------------------
% PreProcessing step 1 - slice time correction
%-------------------------------------

% First param: Scan order 0 -> Ascending, 1 -> Asc-Interleaved, 2 -> Asc-Int2,
% 10 -> Descending, 11 -> Desc-Int, 12 -> Desc-Int2
% Second param: Interpolation method: 0 -> trilinear, 1 -> cubic spline, 2 -> sinc
[ type , ~ ] = detSliceOrder(sliceVector);
fmrProject.CorrectSliceTiming( type , 1);

SliceCorrectedFmrProject = fmrProject.FileNameOfPreprocessdFMR;

fmrProject.Close;

%% -------------------------------------
% PreProcessing step 2 - Correct motion
%-------------------------------------
fmrProject = configs.bvqx.OpenDocument(SliceCorrectedFmrProject);

TargetVolume = 1;

% the current doc (input FMR) knows the name of the automatically saved output FMR
fmrProject.CorrectMotionTargetVolumeInOtherRunEx(...
    fullfile( configs.dataRootSubject,...
        (configs.firstFunctRunName),...
        'PROJECT',...
        'PROCESSING',...
        [ configs.filesSignature  '_' configs.alignRun '.fmr']),...
    TargetVolume, ...% target volume
    2,... % interpolation mode
    true, ... % full dataset
    100,... % number of iterations
    false,... % generate movie
    false); % log file

MotionCorrectedFmrProject = fmrProject.FileNameOfPreprocessdFMR;

fmrProject.Close;

%% -------------------------------------
% PreProcessing step 3: Temporal High Pass Filter, includes Linear Trend Removal
%-------------------------------------

fmrProject = configs.bvqx.OpenDocument(MotionCorrectedFmrProject);

fmrProject.TemporalHighPassFilterGLMFourier(2);

fmrProject.Close; % docFMR.Remove(); // close or remove input FMR

end
