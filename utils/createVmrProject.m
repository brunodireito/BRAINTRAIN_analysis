function [ vmrProject ] = createVmrProject( configs )
%CREATEVMR Summary of this function goes here
%   Detailed explanation goes here

disp('Creating VMR Project...');

% -----------------------
% get first file from anatomical image
% -----------------------
[fileName, pathName] = uigetfile( ...
    {'*.dcm; *.IMA; *.I; *.MR; *.REC;*.hdr','Raw data files (*.dcm,*.IMA,*.I, *.MR, *.REC,*.hdr)';
    '*.dcm', 'DICOM files (*.dcm)'; ...
    '*.IMA','Siemens DICOM files (*.IMA)'; ...
    '*.I','GE I files (*.I)'; ...
    '*.MR','GE MR (*.MR)'; ...
    '*.REC','Philips files (*.REC)'; ...
    '*.hdr','Analyze (*.hdr)'}, ...
    'Please select the first file of the anatomical run', configs.dataRootSubject );

firstFileName = fullfile( pathName, fileName );
[~,~,ext] = fileparts( firstFileName);

switch ext
    case '.dcm', filetype = 'DICOM';
    case '.IMA', filetype = 'SIEMENS';
    case '.I', filetype = 'GE_I';
    case '.MR', filetype = 'GE_MR';
    case '.REC', filetype = 'PHILIPS_REC';
    case '.hdr', filetype = 'ANALYZE';
end

if ( strcmp( ext, '.dcm' ) == 1) && ( exist( 'dicominfo.m' ) > 0 )
    dcminfo = dicominfo( firstFileName );
    bytesperpixel = ( dcminfo.BitsAllocated/8 );
    xres = dcminfo.Columns;
    yres = dcminfo.Rows;
else
    prompt = { 'Size of x-axis:','Size of y-axis:', 'Number of bytes per pixel:' };
    dlgtitle = 'Parameters for VMR project';
    nrlines = 1;
    def = { '256','256', '2' };
    answer = inputdlg( prompt,dlgtitle,nrlines,def );
    xres = answer{ 1 };
    yres = answer{ 2 };
    bytesperpixel = answer{ 3 };
end

rawFileSelection = [ pathName [ '*' ext ] ];
files = dir( rawFileSelection );
sizeAr = size( files );
nrSlices = sizeAr( 1 );

swap = 0;

vmrProject = configs.bvqx.CreateProjectVMR(...
    filetype,...
    firstFileName,...
    nrSlices,...
    swap,...
    xres,...
    yres,...
    bytesperpixel);

vmrProject.SaveAs( fullfile ...
    ( configs.dataRootSubject,...
    'anatomical',...
    'PROJECT',...
    [configs.filesSignature '.vmr']));

%% TRANSFORMATIONS
% Perform inhomogeneity correction and transform VMR to AC-PC and Talairach space

if configs.ATAL || configs.IIHC
    disp('---> Check Brightness and Contrast, then press Enter.')
    pause;
end

if configs.IIHC
    ok = vmrProject.CorrectIntensityInhomogeneities();
    if ok; disp('[createVmrProject] IIHC Performed.'); end
end

if configs.ATAL
    % Transform anatomy to AC-PC and Talairach space
    ok = vmrProject.AutoACPCAndTALTransformation();   
    if ok; disp('[createVmrProject] ATAL Performed.'); end
end

disp('VMR Project created.')

end
