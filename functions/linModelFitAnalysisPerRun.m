
function [p, mdl] = linModelFitAnalysisPerRun(data)
% size(data) = [5,1]

runIdx = 1:4;

tbl = table(runIdx',data');
    
mdl = fitlm(tbl);

fprintf(' p-val of linear regression is %f.\n', mdl.coefTest)
p = mdl.coefTest;

% plot(mdl);

end


    