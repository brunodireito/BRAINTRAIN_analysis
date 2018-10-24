function [  ] = shifterROI( roiFilePath , roiFileName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Read ROI File
file = fopen( fullfile(roiFilePath,roiFileName), 'r'); % read only

tline = fgets(file);

a = cell(1,2);

counter = 1;

% Header
while ischar(tline)
    
    if ~isempty(tline)
        
        a(counter,:) = strsplit(tline,':');
        
        if strcmp(a{counter,1},'NrOfVoxels')
            numVox = str2double(a{counter,2});
            break;
        end
        
        counter = counter + 1;
        
    end
    
    tline = fgetl(file);
    
end

coords = zeros(1,4);

% ROI Coords
for v = 1:numVox
    tline = fgetl(file);
    
    temp = strsplit(tline,' ');
    
    for i = 1:size(temp,2)
        
        coords(v,i) = str2double(temp{i});
        
    end
    
end

fclose( file );

% Shift Coord Y+3
coords(:,1) = [];
coords(:,2) = coords(:,2) + 3;

%% Create ROI File
new_roiFileName = [roiFileName(1:end-4) '_Shifted.roi'];
newROIPath = fullfile(roiFilePath,new_roiFileName);

newFile = fopen( newROIPath , 'wt'); % read only

% Header
for j = 1:size(a,1)
   
    fprintf(newFile, '%s:%s \n', a{j,1}, a{j,2});
    
end

% ROI Coords
for v = 1:numVox

    fprintf(newFile, '%i  %i  %i \n', coords(v,1), coords(v,2), coords(v,3));
    
end

fclose( newFile );

end

