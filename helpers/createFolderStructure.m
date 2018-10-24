function [ success ] = createFolderStructure( datasetConfigs , dataPath , dataTBV , subjectIndex , shiftROI)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

success = false;

D = dir(fullfile(dataPath,'*.ima'));
if length(D) < sum(datasetConfigs.volumes)
    disp('[createFolderStructure] Fewer files than expected...');
elseif length(D) < 5
    D = dir(fullfile(dataPath,'*.dcm'));
end

files = extractfield(D,'name')';

for i=1:length(files)
    
    auxname = files{i};
    aux =  auxname - '0';
    aux2 = find( aux >= 0 & aux < 10, 1 );
    series(i,1) = str2double(auxname(aux2:aux2+3));
    
    %     aux = strsplit(files{i},'.');
    %     series(i,1) = str2double(aux(4));
    
end

seriesNumbers = unique(series);
seriesVolumes = hist(series,length(1:seriesNumbers(end)));
seriesVolumes = seriesVolumes(seriesVolumes~=0);

n_runs = length(datasetConfigs.runs);

% Check for incomplete runs or extra runs
if length(seriesNumbers) > n_runs
    
    ignoreS = seriesNumbers(ismember(seriesVolumes,datasetConfigs.volumes) == 0);
    
    if sum(seriesVolumes == datasetConfigs.volumes(1)) > 1
        
        boolInput = false;
        disp(['[createFolderStructure] More than one run of anatomical data detected: ' num2str(seriesNumbers(seriesVolumes == datasetConfigs.volumes(1))')])
        while ~boolInput
            x = input('Please input the ones to ignore [<series numbers>]: ','s');
            
            if ~ismember(str2double(x),seriesNumbers(seriesVolumes == datasetConfigs.volumes(1)))
                disp('!---> ERROR: Incorrect series number.');
            else
                ignoreS = [ str2double(x) ignoreS ];
                boolInput = true;
            end
        end
    end
    
    if isempty(ignoreS)
        disp(['[createFolderStructure] Ignoring extra files']);
    else
        disp(['[createFolderStructure] Ignoring files with series number of ' num2str(ignoreS')]);
        files(ismember(series,ignoreS)) = [];
        seriesNumbers(ismember(seriesNumbers,ignoreS)) = [];
    end
    
elseif length(seriesNumbers) < length(datasetConfigs.runs)
    disp('[createFolderStructure] !---> ERROR: Unsufficient data.')
    boolInput = false;
    while ~boolInput
        x = input('[createFolderStructure] Do you wish to proceed anyway (Y/N)?','s');
        switch lower(x)
            case 'y'
                n_runs = length(seriesNumbers);
                boolInput = true;
            otherwise
                return
        end
    end
end

% Subject folder
subjectFolder = fullfile(datasetConfigs.path,datasetConfigs.subjects{subjectIndex});

boolInput = false;

if exist(subjectFolder,'dir') == 7
    while ~boolInput
        x = input('[createFolderStructure] Subject Folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
        switch lower(x)
            case 'y'
                rmdir(subjectFolder,'s')
                mkdir(subjectFolder)
                boolInput = true;
            case 'n'
                return
            case 'p'
                success = true;
                return
            otherwise
                disp('[createFolderStructure] !---> ERROR: Invalid input.')
        end
    end
else
    mkdir(subjectFolder)
end

% Iteration runs
for r = 1:n_runs
    
    % Create folder structure
    switch datasetConfigs.runs{r}
        case 'anatomical'
            mkdir(subjectFolder,datasetConfigs.runs{r});
            mkdir(fullfile(subjectFolder,datasetConfigs.runs{r}),'PROJECT');
            auxfolder = fullfile(subjectFolder,datasetConfigs.runs{r},'DATA');
        otherwise
            mkdir(subjectFolder,['run-' datasetConfigs.runs{r} '-data']);
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data']),'PROJECT');
            auxfolder = fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'DATA');
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT'),'PROCESSING');
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT'),'ANALYSIS');
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT'),'TBVTARGET');
            
            % Copy Protocol
            if ~isempty(dir(fullfile(dataTBV,[datasetConfigs.prtPrefix{r-1} '*.prt']))) % .prt in the same folder as .tbv
                
                copyfile(fullfile(dataTBV,[datasetConfigs.prtPrefix{r-1} '*.prt']),fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT','ANALYSIS'));
                
            elseif ~isempty(dir(fullfile(dataTBV,'TargetFolder',[datasetConfigs.prtPrefix{r-1} '*.prt']))) % .prt inside TargetFolder
                
                copyfile(fullfile(dataTBV,'TargetFolder',[datasetConfigs.prtPrefix{r-1} '*.prt']),fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT','ANALYSIS'));
                
            else
                disp('[createFolderStructure] No .prt file found in TBV folder.')
            end
            
    end
    
    % Copy data files
    fprintf('Copying %s files...\n',datasetConfigs.runs{r});
    copyfile(fullfile(dataPath,[ auxname(1:aux2-1) num2str(seriesNumbers(r),'%.4i') '*']) , auxfolder );
    
end

% Copy TBV files
try
    copyfile(fullfile(dataTBV,'*.tbv'),fullfile(subjectFolder,'TBV'));
catch
    disp('[createFolderStructure] No .tbv files found to copy.')
end

% Copy and Shift ROI files
try
    copyfile(fullfile(dataTBV,'NF*.roi'),fullfile(subjectFolder,'TBV'));
    
    if shiftROI
        roiname = dir(fullfile(dataTBV,'NF*.roi'));
        
        for i=1:length(roiname)
            shifterROI(fullfile(subjectFolder,'TBV'),roiname(i).name);
        end
    end
    
catch
    disp('[createFolderStructure] No .roi files found to copy.')
end

success = true;
disp('[createFolderStructure] Folder structure creation completed.')

end

