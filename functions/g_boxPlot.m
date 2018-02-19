
function  g_boxPlot (data, titleStr, xAxisLabels, xAxisLabelStr, yAxisLabelStr, saveImg, sigInfo)
%% input arguments
%
% example: g_boxPlot (data, 'train run PSC results  per session', {'S1', 'S2', 'S3', 'S4', 'S5'}, 'Sessions', '% Signal Change', 0, sigInfo)
%
if nargin < 7
    sigInfo = {};
end

if nargin < 6
    saveImg = 0;
end

if nargin < 5
    yAxisLabelStr = 'Y-axis';
end

if nargin < 4
    xAxisLabelStr = 'X-axis';
end

if nargin < 3
    xAxisLabels = {''};
end

if nargin < 2
    titleStr = '';
end

%% Create Figure
figure('Units', 'pixels', ...
    'Position', [100 100 800 600]);

hold on;

% boxplot structure
hData = boxplot(...
    data,...
    'BoxStyle'       , 'outline'         , ...
    'Colors'         , [0 0 0 ]          , ...
    'MedianStyle'    , 'line'          , ...
    'Symbol'    , 'ko'          , ...
    'Positions',1:1:size(data,2) ,...
    'Widths', .7);

% patch to color the box plots
h = findobj(gca,'Tag','Box');

for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),[.3 .3 .3],'FaceAlpha',.1);
end

% handles to axis, legend, title
hTitle  = title ( titleStr );
hXLabel = xlabel( xAxisLabelStr );
hYLabel = ylabel( yAxisLabelStr );

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');

set(gca, ...
    'Box'         , 'off'       , ...
    'TickDir'     , 'out'       , ...
    'TickLength'  , [.02 .02]   , ...
    'XMinorTick'  , 'off'       , ...
    'YMinorTick'  , 'on'        , ...
    'YGrid'       , 'on'        , ...
    'XColor'      , [.3 .3 .3]  , ...
    'YColor'      , [.3 .3 .3]  , ...
    'YTick'       , floor (min (min (data) ) ):1:ceil(max (max (data) ) ), ...
    'XTick'       , 1:1:5       , ...
    'XTickLabel'  , xAxisLabels , ...
    'LineWidth'   , 1           );


if ~isempty (sigInfo)
   sigstar(sigInfo) 
end

if saveImg
     eval( ['print -dpng ' titleStr] )
end


end