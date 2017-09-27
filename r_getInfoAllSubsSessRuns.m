%%% ======= BRAIN VOYAGER SCRIPT ======= %%%
%%% ======= BrainTrain Analysis ======== %%%
%%% ==================================== %%%

% Add folders to path
addpath('utils');
addpath('functions');

%% Configuration
clear, clc;

% Settings Structure
configs = struct();
rData = struct();

configs.numPats = 15;
configs.numSessions = 5;
configs.numRuns = 5;

configs.patsIdxs = {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15'};
configs.SessIdxs = {'_S1','_S2','_S3','_S4','_S5'};
configs.RunsIdxs = {'loc','train','fv1','fv2','trans'};

%% 

rootPath = 'T:\DATA_ClinicalTrial';

for p = 1: numel( configs.patsIdxs )
    patRootPath = fullfile(char( rootPath ), char( strcat('Subject', configs.patsIdxs{p})) );
    
    for s = 1: numel( configs.SessIdxs )
        sessRootPath = char(strcat( patRootPath, configs.SessIdxs{s} ));
        
        for r = 1: numel( configs.RunsIdxs )
            runRootPath = fullfile(sessRootPath, char(strcat(['run-' configs.RunsIdxs{r} '-data'], '')));
            
            FmrFiles = dir(fullfile( runRootPath, 'PROJECT' , 'PROCESSING', '*.fmr'))
            
            if (~numel(FmrFiles))
                NrOfVolumesPerRun(p,s,r) = -1;
                dataSource{p,s,r} = '';
               
            else
                fmrFile = xff(fullfile( runRootPath, 'PROJECT' , 'PROCESSING',FmrFiles(1).name))           
                NrOfVolumesPerRun(p,s,r) = fmrFile.NrOfVolumes;
                dataSource{p,s,r} = fmrFile.FirstDataSourceFile;
                
            end
        
        end % end of runs for  
    end % end of sessions for
end % end of patients for


%%

 