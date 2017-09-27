
function [p, mdl] = linModelFitAnalysisPerSession(data)
% size(data) = [5,1]

sessionIdx = 1:5;

tbl = table(sessionIdx',data');
    
mdl = fitlm(tbl);

fprintf(' p-val of linear regression is %f.\n', mdl.coefTest)

p= mdl.coefTest;
%plot(mdl);

end


    