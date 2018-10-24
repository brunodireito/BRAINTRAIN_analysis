function [ configs , vmrProject ] = parametersVTCCreation( configs , sliceTypePath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if configs.IIHC
    vmrFileName = fullfile ...
        ( configs.dataRootSubject,...
        'anatomical',...
        'PROJECT',...
        [configs.filesSignature '_IIHC.vmr']);
    if ~exist(vmrFileName, 'file') == 2 % In case the file does not exist
        disp(['[parametersVTCCreation] ' configs.filesSignature '_IIHC.vmr' ' does not exist.']);
        vmrFileName = fullfile ...
            ( configs.dataRootSubject,...
            'anatomical',...
            'PROJECT',...
            [configs.filesSignature '.vmr']);
    end
else
    vmrFileName = fullfile ...
        ( configs.dataRootSubject,...
        'anatomical',...
        'PROJECT',...
        [configs.filesSignature '.vmr']);
end

vmrProject = configs.bvqx.OpenDocument(vmrFileName);

iafaComplete = false;

while ~iafaComplete
    % Create Manually IA and FA transformation matrixes
    % Volumes --> 3D Volume Tools --> Coregistration --> Select FMR --> Align --> Go!
    disp( '---> Create _IA and _FA using the currently open VMR.' )
    disp( [ '---> FMR file to choose: ' configs.firstFunctRunName ] )
    disp('---> Press Enter when done.')
    pause;
    
    vtcPrefix = fullfile( configs.dataRootSubject,...
        configs.firstFunctRunName,...
        'PROJECT',...
        'PROCESSING' );
    
    if configs.IIHC
        configs.iaTransf = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' configs.alignRun '_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c-TO-' configs.filesSignature '_IIHC_IA.trf' ] );
        configs.faTransf = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' configs.alignRun '_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c-TO-' configs.filesSignature '_IIHC_FA.trf' ] );
        
        if configs.ATAL % Automatic TAL
            configs.acpcTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_IIHC_aACPC.trf' ] );
            configs.talTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_IIHC_aACPC.tal' ] );
        elseif configs.MTAL % Manual TAL
            configs.acpcTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_IIHC_ACPC.trf' ] );
            configs.talTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_IIHC_ACPC.tal' ] );
        else %None
            
        end
        
    else
        configs.iaTransf = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' configs.alignRun '_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c-TO-' configs.filesSignature '_IA.trf' ] );
        configs.faTransf = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' configs.alignRun '_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c-TO-' configs.filesSignature '_FA.trf' ] );
        
        if configs.ATAL % Automatic TAL
            configs.acpcTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_aACPC.trf' ] );
            configs.talTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_aACPC.tal' ] );
        elseif configs.MTAL % Manual TAL
            configs.acpcTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_ACPC.trf' ] );
            configs.talTransf = fullfile( configs.dataRootSubject,'anatomical', 'PROJECT', ...
                [ configs.filesSignature '_ACPC.tal' ] );
        else %None
            
        end
          
    end
    
    if (exist(configs.iaTransf,'file') + exist(configs.faTransf,'file')) == 4
        iafaComplete = true;
    else
        disp('---> !!! IA or FA not found. Repeating...')
    end
    
end


end

