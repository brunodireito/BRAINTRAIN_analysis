function voiname =  getTokenSessSubj(fileName)
%% getTokenSessSubj returns the VOI name
% input 
%   - filename - filename to decompose
% output
%   - voiname - new .voi file name
%
% Requires -

% Version 1.0
% - Overall restructure

% Author: Bruno Direito (2018)

% split the voi name using the '_' char
temp = strsplit(fileName, '_');
% create new voi name based on
voiname = strcat( ['VOI1_' temp{4} temp{5} ]);

end



