function [ fmrProject , sliceVector  ] = createFmrProject(  configs, dataFolder )
%CREATEFMRPROJECT Summary of this function goes here
%   Detailed explanation goes here
%
% EXAMPLE
% 

disp('Creating FMR Project...');

fileType = 'DICOM';
byteSwap = 0;
nrVolsInImg = 1;

% select files from functional run
functRoot = fullfile( configs.dataRootSubject, dataFolder, 'DATA' );

rawFilesTemp = fullfile( functRoot, '*dcm');
functionalFiles = dir( rawFilesTemp );

%% Access DICOM info
% select first file from each functional run
functionalFilename = functionalFiles(1).name;
fmrname = fullfile(functRoot, functionalFilename);

dcminfo = dicominfo(fmrname);
sliceVector = dcminfo.Private_0019_1029;

% number of volumes
nrOfVols = size(functionalFiles,1);

% number of slices
if isfield(dcminfo,'Private_0019_100a')
    nrSlices = dcminfo.Private_0019_100a;
else
    nrSlices = 33;
end

skipVols = 0;
createAMR = true;
bytesperpixel = (dcminfo.BitsAllocated/8);
cols = dcminfo.Columns;
rws = dcminfo.Rows;

sizeX = dcminfo.AcquisitionMatrix(1);
sizeY = dcminfo.AcquisitionMatrix(4);

if sizeX == 0 && sizeY ==0
    sizeX = dcminfo.AcquisitionMatrix(2);
    sizeY = dcminfo.AcquisitionMatrix(3);
end

targetFolder = fullfile( configs.dataRootSubject, dataFolder, 'PROJECT', 'PROCESSING' );
runName = strsplit(dataFolder,'-');

%% Creation of functional project
fmrProject = configs.bvqx.CreateProjectMosaicFMR(...
    fileType,...
    fmrname,...
    nrOfVols,...
    skipVols,...
    createAMR,...
    nrSlices,...
    configs.filesSignature,... 
    byteSwap,...
    cols,...
    rws,...
    bytesperpixel,...
    targetFolder,... 
    nrVolsInImg,...
    sizeX,...
    sizeY);

fmrProject.SaveAs( fullfile ...
        ( targetFolder,...
         [ configs.filesSignature '_' runName{2} '.fmr' ] ) );

% Link .prt file to -fmr Project
prtName = dir(fullfile( configs.dataRootSubject, dataFolder, 'PROJECT', 'ANALYSIS', '*.prt' ) );

success = fmrProject.LinkStimulationProtocol( fullfile( configs.dataRootSubject, dataFolder, 'PROJECT', 'ANALYSIS', prtName.name ) );

if success
    disp( ['FMR Project created: ' fullfile( targetFolder,[ configs.filesSignature '_' runName{2} '.fmr' ] ) ]);
    fmrProject.SaveAs(  fullfile ...
        ( targetFolder,...
         [ strcat(configs.filesSignature,'_',runName{2}) '.fmr' ] ) );
else
    disp('PRT File not found. FMR created without link to PRT.');
end

end
