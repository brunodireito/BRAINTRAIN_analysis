function renameDirectoryDcm ( filePath )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% renamedirectory_dcm.m. Rename DICOM files in directory
% 
% This script renames *.dcm files in a directory that is
% indicated by the user. 
%
% Creation of file names:
% a. BrainVoyager renaming style (only possible and presented when the
% function 'dicominfo()' is available in Matlab):
% BrainVoyager renaming scheme: 
% <description>_<date>-<series>-<volume>-<cumulative slice number>.dcm
% (anonymized. For naming exactly identical to BrainVoyager, change line 76 to:
%   descr = [dcmInfo.PatientsName.FamilyName '^' dcmInfo.PatientsName.GivenName];
% b. Original file name. In this case the basename is the original
% filename and the numbering and extension are just added: 
% <basename>_00001.dcm
% c. User specified filename. The user can enter a new name which is used
% as basename. The numbering and extension are just added: 
% <basename>_00001.dcm
%
% Use of the script: a. load in Matlab b. press 'run'
%
% Notes: 
% - Files with other extensions than *.dcm in the directory are ignored.
% - No reordering of the filenames in the filename array takes place, so
% please check afterwards whether the renaming proceeded in the correct
% order (not relevant in case of BrainVoyager renaming style).
% - When using BrainVoyager renaming style (via dicominfo()) and the 
% header values in the DICOM file are not properly specified, Matlab may 
% generate an error (f.e. 'Attribute X has inconsistent length') and the 
% script will stop. The other renaming schemes can be used for these cases.
%
% Hester Breman, Brain Innovation 2005.
% Fixed double line (85), used extension array to include IMA files,
% fixed typo 25-07-14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imaExt = '.IMA';
dcmExt = '.dcm';
extArray = {'*.dcm;*.IMA','DICOM files'; ['*' dcmExt],'DICOM file';  ['*' dcmExt],'Siemens DICOM file'};
dcmSelection = [];
% 
% if exist('dicominfo') == 2
%     h = msgbox('This script will rename DICOM files. The BrainVoyager naming style is <descr>_<date>-<series>-<acquisitionnr>-<instancenr>.dcm, and the other is <basename>_<filenumber>.dcm', 'Rename DICOM files');
%     uiwait(h);
% else 
%     h = msgbox('This script will rename DICOM files. The naming scheme is <basename>_<filenumber>.dcm', 'Rename DICOM files');
%     uiwait(h);
% end
    
%[FileName,PathName] = uigetfile(extArray);%('*.dcm','Please select the first DICOM file...');

disp('Renaming files using BrainVoyager DICOM naming style...');

[pathName,fileName,usrex] = fileparts (filePath);
if strcmp(usrex,dcmExt)
    dcmSelection =  fullfile(pathName, '*.dcm');
elseif strcmp(usrex,imaExt)
    dcmSelection = fullfile(pathName, '*.IMA');
end

disp(dcmSelection)
files = dir(dcmSelection);
frstFile = fullfile(pathName, [fileName usrex]);%strcat(PathName, FileName);
dcmInfo = dicominfo(frstFile);
sizedir = size(files);

orig = false;
bvstyle = false;
usrspec = false;

%[basename, ext] = strtok(files(1).name,'.');
% if exist('dicominfo') == 2
%     namingchoice = questdlg('What filenaming system would you like?','Renaming DICOM files','Use BrainVoyager DICOM naming style', 'Use original filename','User specified','Use BrainVoyager DICOM naming style');
% else
%     namingchoice = questdlg('What filenaming system would you like? (the file number and extension will be added automatically, f.e. <basename>_00001.hdr)','Renaming DICOM files','Use original filename','Use shortened original filename','User specified','Use original filename');
% end
% 
% if strcmp(namingchoice,'User specified')
%     usrspec = true;
%     basenameUsr = inputdlg('Please specify the new basename (the file number and extension will be added automatically, f.e. <basename>_00001.hdr )', 'Create new basename',1,cellstr(basename));
% elseif strcmp(namingchoice,'Use BrainVoyager DICOM naming style')
%     bvstyle = true;
% else 
%     orig = true;
% end

%namingchoice = 'Use BrainVoyager DICOM naming style';
bvstyle = true;

for i=1:sizedir(1)      
    [basename,ext] = fileparts(files(i).name);
    if bvstyle        
        dcmInfo = dicominfo(fullfile(pathName, files(i).name));
        descr = dcmInfo.StudyDescription;
        acqDate = dcmInfo.StudyDate;
        seriesNr = num2str(dcmInfo.SeriesNumber, '%04d');
        acqNr = num2str(dcmInfo.AcquisitionNumber, '%04d');
        instNr = num2str(dcmInfo.InstanceNumber, '%04d');
        newname = fullfile(pathName,[ descr '_' acqDate '-' seriesNr '-' acqNr '-' instNr]);
    elseif usrspec, newname = [pathName basenameUsr{1} '_' num2str(i,'%05d')];
    else newname = [pathName basename '_' num2str(i,'%05d')];
    end
    [status,message,messageid] = movefile(fullfile(pathName, files(i).name), [newname dcmExt]);
  %  disp([newname exthdr]);    
end

