function [ ok ] = vmrTransformation( vmrProject )
%vmrTransformation Summary of this function goes here
%   Detailed explanation goes here
%
% EXAMPLE
% 


%% open FmrProject

% vmrProject = configs.bvqx.ActiveDocument;

ok = vmrProject.CorrectIntensityInhomogeneities();
% Transform anatomy to AC-PC and Talairach space

ok = vmrProject.AutoACPCAndTALTransformation();


end















