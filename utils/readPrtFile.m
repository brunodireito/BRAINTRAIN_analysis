function [ conds ] = readPrtFile( StimulationProtocolFile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

conds = [];

file = fopen( StimulationProtocolFile, 'r'); % read only

tline = fgets(file);

counter  = 1;

while ischar(tline)
    if strfind( tline, 'NrOfConditions:')
        [ ~, nrConditions ] = strtok (tline);
        break
    elseif strfind( tline, 'NrOfCondition:')
         [ ~, nrConditions ] = strtok (tline);
        break
    end
    tline = fgets(file);
end

while ischar(tline)
    if isempty ( tline )
        
        tline = fgetl(file);
        if ~isempty(tline)
            conds{counter} = tline;
            counter = counter + 1;
        end
        
    end
    tline = fgetl(file)
end

fclose( file );

end
