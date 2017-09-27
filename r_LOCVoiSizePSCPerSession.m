%%% ======= BRAIN VOYAGER SCRIPT ======= %%%
%%% ======= BrainTrain Analysis ======== %%%
%%% ==================================== %%%

% Add folders to path
addpath('utils');
addpath('data');
addpath('functions');


%% ------------------------------------

% Load data
load('nfasd_roiglm_results.mat');
load('ROIsize.mat');
load('psc.mat');


%% ------------------------------------

% Settings Structure

configs = struct();
rData = struct();

configs.numPats = 15;
configs.numSessions = 5;
configs.numRuns = 5;

configs.patsIdxs = {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15'};
configs.SessIdxs = {'_S1','_S2','_S3','_S4','_S5'};
configs.colorsPerSess = copper(configs.numSessions);

%% ------------------------------------

% Data re-org


for s = 1:length(configs.SessIdxs)
    
    sessIdx = configs.SessIdxs{s};
    
    % Get rows for the sessIdx
    r_rows = find(contains(sessionPerPatient, sessIdx ) );

    % re-organize data per session
    r_ROIsizePerSession (:,s) = ROIsizePerSession (r_rows, : );
    
end

%% ------------------------------------

% Data PSC re-org


for s = 1:length(configs.SessIdxs)
    
    sessIdx = configs.SessIdxs{s};
    
    % Get rows for the sessIdx
    r_rows = find(contains(sessionPerPatient, sessIdx ) );

    % re-organize data per session
    r_PSCPerSession (:,s) = psc (r_rows, 1 );
    
end

%% ------------------------------------


r_boxPlot(r_ROIsizePerSession)

% Stat analysis
[p, tbl, stats ] = anova1(r_ROIsizePerSession);

fprintf('ANOVA, ROI size per Session - %.3f.\n',  p);

%%
% Repeated measures ANOVA

[anovatblROIperSession] = reapMeasAnovaPerSession(r_ROIsizePerSession)

%% -------------------------------------
% PSC localizer persession

r_boxPlot(r_PSCPerSession)


% Stat analysis

[p, tbl, stats ] = anova1(r_PSCPerSession);

fprintf('ANOVA, PSC LOC per Session - %.3f.\n',  p);

lm = fitlm( 1:5,mean(r_PSCPerSession),'linear')
figure, 
lm.plot


%%
% Repeated measures ANOVA

[anovatblPSCLocPerSess] = reapMeasAnovaPerSession(r_PSCPerSession);


%%

t_PSC = mean(r_PSCPerSession);

sessionIdx = 1:5;

tbl = table(sessionIdx',t_PSC');
    
mdl = fitlm(tbl);

fprintf(' p-val of linear regression is %f.\n', mdl.coefTest)

plot(mdl);


    





