%% ??
% Script ??
% Requires ??

% Version 1.0
% - Overall restructure

% Author: Bruno Direito (2018)

%%

for i = 1:7
    new_feats (:,i) = data_raw(:,i+7) - data_raw(:,i);
end

%%

new_feats (:,8) = data_raw (:,16) - data_raw(:,15);
new_feats (:,9) = data_raw (:,18) - data_raw(:,17);

%%

counter  = 10;
for i = 19:25
    new_feats (:,counter) = data_raw(:,i+7) - data_raw(:,i);
    counter = counter + 1;
end
