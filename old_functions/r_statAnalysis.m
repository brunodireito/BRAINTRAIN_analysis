%%% ======= BRAIN VOYAGER SCRIPT ======= %%%
%%% ======= BrainTrain Analysis ======== %%%
%%% ==================================== %%%

% Add folders to path
addpath('utils');
addpath('data');
addpath('functions');


%% Configuration
clear, clc, close all;

%% options
absoluteValues = 0;

% Settings Structure
configs = struct();
rData = struct();

configs.numPats = 15;
configs.numSessions = 5;
configs.numRuns = 5;

configs.patsIdxs = {"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"};
configs.SessIdxs = {"_S1","_S2","_S3","_S4","_S5"};
configs.RunsIdxs = {"loc t","train t","fv1 t","fv2 t","trans t"};
configs.colorsPerSess = copper(configs.numSessions);
configs.colorsPerRun = copper(configs.numRuns - 1); % ignore localizer
configs.colorsPerPat = copper(configs.numPats);


%% Initalization and Subject Selection

% Load data
load('nfasd_roiglm_results.mat');


%% stat analysis - per session
% Wilcoxon Signed Rank Test and ANOVA

% CLEAR DATA????
clear results_Subset header r_rows r_columns

for s_idx = 1:length(configs.SessIdxs)
    

    % select subset
    header = " t";
    % Get rows for the patientIdx
    r_rows = find(contains(sessionPerPatient, configs.SessIdxs{s_idx} ) );
    % Get columns
    r_columns = find(contains(headers, header ) );
    % Create subset based on the rows and columns selected excluding localizer
    if absoluteValues
        results_Subset = abs(results (r_rows ,r_columns (2:5)));
    else
        results_Subset = (results (r_rows ,r_columns (2:5)));
    end
    
    % Wilcoxon Signed Rank Test - Compare train with transfer per session
    [rData.session{s_idx}.WilcoxonSignedRankTest.p,...
        rData.session{s_idx}.WilcoxonSignedRankTest.h,...
        rData.session{s_idx}.WilcoxonSignedRankTest.stats ] = ...
        signrank( ...
        results_Subset(:,1),...
        results_Subset(:,4) );
    
    fprintf('Wilcoxon test - session %i %.3f.\n',s_idx,  rData.session{s_idx}.WilcoxonSignedRankTest.p);

    [rData.session{s_idx}.ANOVA.p,...
        rData.session{s_idx}.ANOVA.tbl,...
        rData.session{s_idx}.ANOVA.stats ] = anova1(results_Subset);
    
    fprintf('ANOVA - session %i %.3f.\n',s_idx,  rData.session{s_idx}.ANOVA.p);
    
    
end

fprintf('\n')

% re-display results for copy
fprintf('DATA per SESSION!!! \n')
for s_idx = 1:length(configs.SessIdxs)
    
    fprintf('%.3f, %.3f \n',rData.session{s_idx}.WilcoxonSignedRankTest.p ,  rData.session{s_idx}.ANOVA.p);
    
end

fprintf('\n')

%% stat analysis - per subject
% Wilcoxon Signed Rank Test and ANOVA

% CLEAR DATA????
clear results_Subset header r_rows r_columns

for p_idx = 1:length(configs.patsIdxs)
    
    % select subset
    header = " t";
    % Get rows for the patientIdx
    r_rows = find(contains(sessionPerPatient, configs.patsIdxs{p_idx} ) );
    % Get columns
    r_columns = find(contains(headers, header ) );
    % Create subset based on the rows and columns selected excluding localizer
    if absoluteValues
        results_Subset = abs(results (r_rows ,r_columns (2:5)));
    else
        results_Subset = results (r_rows ,r_columns (2:5));
    end
    
    % Wilcoxon Signed Rank Test - Compare train with transfer per session
    [rData.patient{p_idx}.WilcoxonSignedRankTest.p,...
        rData.patient{p_idx}.WilcoxonSignedRankTest.h,...
        rData.patient{p_idx}.WilcoxonSignedRankTest.stats ] = ...
        signrank( ...
        results_Subset(:,1),...
        results_Subset(:,4) );
    
    fprintf('Wilcoxon test - patient %i %.3f.\n',p_idx,  rData.patient{p_idx}.WilcoxonSignedRankTest.p);

    [rData.patient{p_idx}.ANOVA.p,...
        rData.patient{p_idx}.ANOVA.tbl,...
        rData.patient{p_idx}.ANOVA.stats ] = anova1(results_Subset);
    
    fprintf('ANOVA - patient %i %.3f.\n',p_idx,  rData.patient{p_idx}.ANOVA.p);
    
    
end


fprintf('\n')

% re-display results for copy
fprintf('DATA per PATIENT!!! \n')
for p_idx = 1:length(configs.patsIdxs)
    
    fprintf('%.3f, %.3f \n',rData.patient{p_idx}.WilcoxonSignedRankTest.p ,  rData.patient{p_idx}.ANOVA.p);
    
end

fprintf('\n')



%% stat analysis - per run
% Wilcoxon Signed Rank Test and ANOVA

% CLEAR DATA????
clear results_Subset header r_rows r_columns

for r_idx = 1:5 % 1- loc, 2- train, etc.
    
    header = configs.RunsIdxs{r_idx}
    results_Subset = [];
    
    % Get columns - SAME RUN ALL ITERATIONS
    r_columns = find(contains(headers, header ) );
    
    % create organized dataset subset [pats x sessions]
    for s = 1 : length( configs.SessIdxs )
        % Get rows for the sessionIdx
        r_rows = find(contains(sessionPerPatient, configs.SessIdxs{s} ) )
        
        results_Subset = [results_Subset results(r_rows, r_columns)];
        
    end
    
    % if we want absolute values
    if absoluteValues
        results_Subset = abs(results_Subset);
    end
    
    % Wilcoxon Signed Rank Test - Compare s1 with s5 per run
    [rData.run{r_idx}.WilcoxonSignedRankTest.p,...
        rData.run{r_idx}.WilcoxonSignedRankTest.h,...
        rData.run{r_idx}.WilcoxonSignedRankTest.stats ] = ...
        signrank( ...
            results_Subset(:,1),...
            results_Subset(:,5)...
        );
    
    fprintf('Wilcoxon test - run %s %.3f.\n',header,  rData.run{r_idx}.WilcoxonSignedRankTest.p);

    [rData.run{r_idx}.ANOVA.p,...
        rData.run{r_idx}.ANOVA.tbl,...
        rData.run{r_idx}.ANOVA.stats ] = anova1(results_Subset);
    
    fprintf('ANOVA - run %s %.3f.\n',header,  rData.run{r_idx}.ANOVA.p);
    
       
end


fprintf('\n')

% re-display results for copy
fprintf('DATA per RUN!!! \n')
for r_idx = 1:5
    
    fprintf('%.3f, %.3f \n',rData.run{r_idx}.WilcoxonSignedRankTest.p ,  rData.run{r_idx}.ANOVA.p);
    
end

fprintf('\n')


%% Wilcoxon Signed Rank Test - 1st train vs. 5th transfer

% CLEAR DATA????
clear results_Subset header r_rows r_columns

% Initialize results_subset
results_Subset = [];
% 1.Session1 and 5.session5
sess_idx = [1 5];
% 2.TRAIN and 5.TRANSFER
runs_idx = [2 5];

% create organized dataset subset [num_pats x trains1,transs5] size(15, 2)
for i = 1:2
    % Get rows for the sessionIdx
    r_rows = find(contains(sessionPerPatient, configs.SessIdxs{sess_idx(i)} ) );
    % Get columns
    r_columns = find(contains(headers, configs.RunsIdxs{runs_idx(i)} ) );

    results_Subset = [results_Subset results(r_rows, r_columns)];

end

% if we want absolute values
if absoluteValues
    results_Subset = abs(results_Subset);
end

% Wilcoxon Signed Rank Test - Compare s1 with s5 per run
[rData.trainVsTrans.WilcoxonSignedRankTest.p,...
    rData.trainVsTrans.WilcoxonSignedRankTest.h,...
    rData.trainVsTrans.WilcoxonSignedRankTest.stats ] = ...
    signrank( ...
        results_Subset(:,1),...
        results_Subset(:,2)...
    );

fprintf('Wilcoxon test - trains1 vs transs5 %.3f.\n',  rData.trainVsTrans.WilcoxonSignedRankTest.p);

   