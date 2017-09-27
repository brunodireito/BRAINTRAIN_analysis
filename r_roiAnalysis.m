% Create ROItoVOI file
% Initialize vars
clear, clc,

basePath = 'T:\DATA_ClinicalTrial\ANALYSIS\VOI-data\';
basePathSess =  'T:\DATA_ClinicalTrial';

files = dir('T:\DATA_ClinicalTrial\ANALYSIS\VOI-data\*_TAL_.voi');

roiData = struct();

voiFile = [];

%%

for i = 1:numel( files )
    
    % e.g. 'T:\DATA_ClinicalTrial\Subject01_S1\run-loc-data\PROJECT\ANALYSIS\NF_Target_TAL_Subject01_S1.voi'
    voiFile = xff( fullfile ( basePath, files(i).name ) );
    
    roiData(i).nrOfVoxels = voiFile.VOI.NrOfVoxels;
    roiData(i).Voxels = voiFile.VOI.Voxels;
    
    roiData(i).meanCenterPerCoordX = round( mean( voiFile.VOI.Voxels (:,1) ) );
    roiData(i).meanCenterPerCoordY = round( mean( voiFile.VOI.Voxels (:,2)) );
    roiData(i).meanCenterPerCoordZ = round( mean( voiFile.VOI.Voxels (:,3)) );
    
    
end

%% --- OVERLAP ANALYSIS ---


poolPoints = [];
hist_poolPoints = 0;

for i =1: numel(roiData)
    disp (['ROI - ' num2str(i)]);
    
    for n = 1:roiData(i).nrOfVoxels
        [posPool, boolPool] = pntInPool(roiData(i).Voxels(n,:), poolPoints);
        if boolPool
            hist_poolPoints( length(hist_poolPoints) + 1 ) = posPool;
        else
            poolPoints = [poolPoints; roiData(i).Voxels(n,:)];
        end
    end
end

%%

max(hist_poolPoints),

min(hist_poolPoints)

figure,
h = histogram(hist_poolPoints, 'binMethod', 'integer')

%TODO check if these are the corresponding points
poolPoints(h.Data(find (h.Values+1 > 10)),:)

%%
% total number of voxels

tnVox = 0;
for i = 1: numel(roiData)
    tnVox = tnVox + (roiData(i).nrOfVoxels);
end

%% Overlap analysis per Patient


r_hist = struct();
for p = 1 : 15 % num of patients
    
    poolPointsPat = [];
    hist_poolPointsPat = 0;
    
    for i = 1 : 5 % num of sessions
        disp (['ROI - ' num2str(i)]);
        
        sessIdx = (p - 1) * 5 + i;
        
        for n = 1:roiData(sessIdx).nrOfVoxels
            [posPool, boolPool] = pntInPool(roiData(sessIdx).Voxels(n,:), poolPointsPat);
            if boolPool
                hist_poolPointsPat( length(hist_poolPointsPat) + 1 ) = posPool;
            else
                poolPointsPat = [poolPointsPat; roiData(sessIdx).Voxels(n,:)];
            end
        end
    end
    

    figure,
    h = histogram(hist_poolPointsPat, 'binMethod', 'integer');
    
    r_hist(p).h_Values = h.Values;
    r_hist(p).h_Data = h.Data;
    r_hist(p).h_histPool = hist_poolPointsPat;
    r_hist(p).h_poolPointsPat = poolPointsPat;
         
end

%%

for t = 1:15
    
    fprintf('num of voxels repeated 5 times %i in patient %i\n', sum(r_hist(t).h_Values+1 == 5), t );
    fprintf('num of voxels repeated 4 times %i in patient %i\n', sum(r_hist(t).h_Values+1 == 4), t );    
    fprintf('num of voxels repeated 3 times %i in patient %i\n', sum(r_hist(t).h_Values+1 == 3), t );
    fprintf('num of voxels repeated 2 times %i in patient %i\n\n', sum(r_hist(t).h_Values+1 == 2), t );
    
    VoxIn5SessPerPat(t) = sum(r_hist(t).h_Values+1 == 5);
    VoxIn4SessPerPat(t) = sum(r_hist(t).h_Values+1 == 4);
    VoxIn3SessPerPat(t) = sum(r_hist(t).h_Values+1 == 3);
    
end

find(VoxIn5SessPerPat)
find(VoxIn4SessPerPat)
find(VoxIn3SessPerPat)



