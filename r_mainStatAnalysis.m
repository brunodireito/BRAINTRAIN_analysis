%% r_mainStatAnalysis

%%% ======= BRAIN VOYAGER SCRIPT ======= %%%
%%% ======= BrainTrain Analysis ======== %%%
%%% ==================================== %%%

% Add folders to path
addpath('utils');
addpath('data');
addpath('functions');


%% Configuration
clear, clc, close all;

%% Settings Structure
configs = struct();

configs.numPats = 15;
configs.numSessions = 5;
configs.numRuns = 5;

configs.patsIdxs = {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15'};
configs.SessIdxs = {'S1','S2','S3','S4','S5'};
configs.RunsIdxs = {'loc','train','fv1','fv2','trans'};

%% Initalization and Subject Selection

% Load data
load('data_ROIGLM.mat');


%% Define question!!!

% CLEAR DATA
clear data_subset tags_subset data_rows data_columns data_results

% present graphical representation?
presGraphs = 1;

% new analysis with absolute values?
absoluteValues = 0;

% measure / subset
tag = ' psc';
graphTitle = 'success rate';


%% stat analysis - WITHIN SESSION
% Wilcoxon Signed Rank Test and repeated-measures ANOVA

for s_idx = 1:length(configs.SessIdxs)
    
    % Get rows for the patientIdx
    data_rows = find(contains(p_ROIGLM, configs.SessIdxs{s_idx} ) );
    
    % Get columns
    data_columns = find(contains(t_ROIGLM, tag ) );
    
    % Create subset based on the rows and columns selected excluding localizer
    if absoluteValues
        data_subset = abs(r_ROIGLM (data_rows ,data_columns (2:5)));
    else
        data_subset = (r_ROIGLM (data_rows ,data_columns (2:5)));
    end
    
    % Wilcoxon Signed Rank Test - Compare train with transfer per session
    [data_results.session{s_idx}.WilcoxonSignedRankTest.p,...
        data_results.session{s_idx}.WilcoxonSignedRankTest.h,...
        data_results.session{s_idx}.WilcoxonSignedRankTest.stats ] = ...
        signrank( ...
        data_subset(:,1),...
        data_subset(:,4), 'method', 'approximate' );
    
    fprintf('Wilcoxon test (Train vs. Transf.) - session %i %.3f. , median train = %.3f and median transfer = %.3f \n',...
        s_idx,...
        data_results.session{s_idx}.WilcoxonSignedRankTest.p,...
        median (data_subset(:,1)),...
        median (data_subset(:,4)) );
    
    
    
    [anovatblPSCLocPerSess] = reapMeasAnovaPerRun(data_subset);
    
    data_results.session{s_idx}.ANOVA.p = anovatblPSCLocPerSess.pValue(1);
    data_results.session{s_idx}.ANOVA.F = anovatblPSCLocPerSess.F;
    
    data_results.session{s_idx}.ANOVA.DF = anovatblPSCLocPerSess.DF;
    
    fprintf('repeated meas. ANOVA - session %i -  %.3f \n', s_idx, data_results.session{s_idx}.ANOVA.p);
    
    
    if presGraphs
        g_linePlotPerPatient( data_subset,...
            configs.numPats,...
            [graphTitle '-lp-' configs.SessIdxs{s_idx}],...
            'Run',...
            tag,...
            1 )
        g_boxPlot (data_subset,...
            [graphTitle '-bp-' configs.SessIdxs{s_idx}],...
            {'train', 'neurofeedback #1', 'neurofeedback #2', 'transfer' },...
            'Runs' ,...
            '% Signal Change',...
            1 )
    end
    
end

fprintf('\n')

% re-display results for copy
fprintf('DATA per SESSION!!! \n')
for s_idx = 1:length(configs.SessIdxs)
    
    fprintf('%.3f, %.3f \n',data_results.session{s_idx}.WilcoxonSignedRankTest.p ,  data_results.session{s_idx}.ANOVA.p);
    
end

fprintf('\n')


%% stat analysis - ACROSS SESSION
% Wilcoxon Signed Rank Test and repeated-measures ANOVA

for r_idx = 2:5 % 2- train, 3-neurofeedback.
    
    data_subset = [];
    
    % Define run
    t_tag = [configs.RunsIdxs{r_idx} tag];
    
    % Get columns - SAME RUN ALL ITERATIONS
    r_columns = find(contains(t_ROIGLM, t_tag ) );
    
    % create organized dataset subset [pats x sessions]
    for s = 1 : length( configs.SessIdxs )
        
        % Get rows for the sessionIdx
        r_rows = find(contains(p_ROIGLM, configs.SessIdxs{s} ) );
        
        data_subset = [data_subset r_ROIGLM(r_rows, r_columns)];
        
    end
    
    % if we want absolute values
    if absoluteValues
        data_subset = abs(data_subset);
    end
    
    % Wilcoxon Signed Rank Test - Compare s1 with s5 per run
    [data_results.run{r_idx}.WilcoxonSignedRankTest.p,...
        data_results.run{r_idx}.WilcoxonSignedRankTest.h,...
        data_results.run{r_idx}.WilcoxonSignedRankTest.stats ] = ...
        signrank( ...
        data_subset(:,1),...
        data_subset(:,5),...
        'method', 'approximate');
    
    fprintf('Wilcoxon test (Train vs. Transf.) - run = %s, p = %.3f. , median train = %.3f and median transfer = %.3f \n',...
        t_tag,...
        data_results.run{r_idx}.WilcoxonSignedRankTest.p,...
        median (data_subset(:,1)),...
        median (data_subset(:,5)) );
    
       
    [anovatbl] = reapMeasAnovaPerSession(data_subset);
    
    data_results.run{r_idx}.ANOVA.p = anovatbl.pValue(1);
    data_results.run{r_idx}.ANOVA.F = anovatbl.F;
    
    data_results.run{r_idx}.ANOVA.DF = anovatbl.DF;
    
    fprintf('repeated meas. ANOVA - session %s -  %.3f \n', t_tag, data_results.run{r_idx}.ANOVA.p);
    
    
    if presGraphs
        g_linePlotPerPatient( data_subset,...
            configs.numPats,...
            [graphTitle '-lp-' configs.RunsIdxs{r_idx}],...
            'Session',...
            tag,...
            {'Session #1', 'Session #2', 'Session #3', 'Session #4', 'Session #5'},...
            0 )
         
        g_boxPlot (data_subset,...
            [graphTitle '-bp-' configs.RunsIdxs{r_idx}],...
            {'Session #1', 'Session #2', 'Session #3', 'Session #4', 'Session #5'},...
            'Session' ,...
            '% Signal Change',...
            0 )
    end
    
end

%
% fprintf('\n')
%
% % re-display results for copy
% fprintf('DATA per RUN!!! \n')
% for r_idx = 1:5
%
%     fprintf('%.3f, %.3f \n',data_results.run{r_idx}.WilcoxonSignedRankTest.p ,  data_results.run{r_idx}.ANOVA.p);
%
% end
%
% fprintf('\n')





%% stat analysis - per subject
% Wilcoxon Signed Rank Test and ANOVA

% for p_idx = 1:length(configs.patsIdxs)
%
%     % select subset
%     header = " t";
%     % Get rows for the patientIdx
%     r_rows = find(contains(sessionPerPatient, configs.patsIdxs{p_idx} ) );
%     % Get columns
%     r_columns = find(contains(headers, header ) );
%     % Create subset based on the rows and columns selected excluding localizer
%     if absoluteValues
%         results_Subset = abs(results (r_rows ,r_columns (2:5)));
%     else
%         results_Subset = results (r_rows ,r_columns (2:5));
%     end
%
%     % Wilcoxon Signed Rank Test - Compare train with transfer per session
%     [data_results.patient{p_idx}.WilcoxonSignedRankTest.p,...
%         data_results.patient{p_idx}.WilcoxonSignedRankTest.h,...
%         data_results.patient{p_idx}.WilcoxonSignedRankTest.stats ] = ...
%         signrank( ...
%         results_Subset(:,1),...
%         results_Subset(:,4) );
%
%     fprintf('Wilcoxon test - patient %i %.3f.\n',p_idx,  data_results.patient{p_idx}.WilcoxonSignedRankTest.p);
%
%     [data_results.patient{p_idx}.ANOVA.p,...
%         data_results.patient{p_idx}.ANOVA.tbl,...
%         data_results.patient{p_idx}.ANOVA.stats ] = anova1(results_Subset);
%
%     fprintf('ANOVA - patient %i %.3f.\n',p_idx,  data_results.patient{p_idx}.ANOVA.p);
%
%
% end
%
%
% fprintf('\n')
%
% % re-display results for copy
% fprintf('DATA per PATIENT!!! \n')
% for p_idx = 1:length(configs.patsIdxs)
%
%     fprintf('%.3f, %.3f \n',data_results.patient{p_idx}.WilcoxonSignedRankTest.p ,  data_results.patient{p_idx}.ANOVA.p);
%
% end
%
% fprintf('\n')
%
%
%
% %% stat analysis - per run
% % Wilcoxon Signed Rank Test and ANOVA
%
% % CLEAR DATA????
% clear results_Subset header r_rows r_columns
%
% for r_idx = 1:5 % 1- loc, 2- train, etc.
%
%     header = configs.RunsIdxs{r_idx}
%     results_Subset = [];
%
%     % Get columns - SAME RUN ALL ITERATIONS
%     r_columns = find(contains(headers, header ) );
%
%     % create organized dataset subset [pats x sessions]
%     for s = 1 : length( configs.SessIdxs )
%         % Get rows for the sessionIdx
%         r_rows = find(contains(sessionPerPatient, configs.SessIdxs{s} ) )
%
%         results_Subset = [results_Subset results(r_rows, r_columns)];
%
%     end
%
%     % if we want absolute values
%     if absoluteValues
%         results_Subset = abs(results_Subset);
%     end
%
%     % Wilcoxon Signed Rank Test - Compare s1 with s5 per run
%     [data_results.run{r_idx}.WilcoxonSignedRankTest.p,...
%         data_results.run{r_idx}.WilcoxonSignedRankTest.h,...
%         data_results.run{r_idx}.WilcoxonSignedRankTest.stats ] = ...
%         signrank( ...
%         results_Subset(:,1),...
%         results_Subset(:,5)...
%         );
%
%     fprintf('Wilcoxon test - run %s %.3f.\n',header,  data_results.run{r_idx}.WilcoxonSignedRankTest.p);
%
%     [data_results.run{r_idx}.ANOVA.p,...
%         data_results.run{r_idx}.ANOVA.tbl,...
%         data_results.run{r_idx}.ANOVA.stats ] = anova1(results_Subset);
%
%     fprintf('ANOVA - run %s %.3f.\n',header,  data_results.run{r_idx}.ANOVA.p);
%
%
% end
%
%
% fprintf('\n')
%
% % re-display results for copy
% fprintf('DATA per RUN!!! \n')
% for r_idx = 1:5
%
%     fprintf('%.3f, %.3f \n',data_results.run{r_idx}.WilcoxonSignedRankTest.p ,  data_results.run{r_idx}.ANOVA.p);
%
% end
%
% fprintf('\n')
%
%
% %% Wilcoxon Signed Rank Test - 1st train vs. 5th transfer
%
% % CLEAR DATA????
% clear results_Subset header r_rows r_columns
%
% % Initialize results_subset
% results_Subset = [];
% % 1.Session1 and 5.session5
% sess_idx = [1 5];
% % 2.TRAIN and 5.TRANSFER
% runs_idx = [2 5];
%
% % create organized dataset subset [num_pats x trains1,transs5] size(15, 2)
% for i = 1:2
%     % Get rows for the sessionIdx
%     r_rows = find(contains(sessionPerPatient, configs.SessIdxs{sess_idx(i)} ) );
%     % Get columns
%     r_columns = find(contains(headers, configs.RunsIdxs{runs_idx(i)} ) );
%
%     results_Subset = [results_Subset results(r_rows, r_columns)];
%
% end
%
% % if we want absolute values
% if absoluteValues
%     results_Subset = abs(results_Subset);
% end
%
% % Wilcoxon Signed Rank Test - Compare s1 with s5 per run
% [data_results.trainVsTrans.WilcoxonSignedRankTest.p,...
%     data_results.trainVsTrans.WilcoxonSignedRankTest.h,...
%     data_results.trainVsTrans.WilcoxonSignedRankTest.stats ] = ...
%     signrank( ...
%     results_Subset(:,1),...
%     results_Subset(:,2)...
%     );
%
% fprintf('Wilcoxon test - trains1 vs transs5 %.3f.\n',  data_results.trainVsTrans.WilcoxonSignedRankTest.p);
%
