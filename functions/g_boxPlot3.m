
function  g_boxPlot3(data, titleStr, xAxisLabels, xAxisLabelStr, yAxisLabelStr, saveImg, imgName, sigInfo)
%% input arguments
%
% example: g_boxPlot3 (data, 'train run PSC results  per session', {'S1', 'S2', 'S3', 'S4', 'S5'}, 'Sessions', '% Signal Change', 0, sigInfo)
%
if nargin < 8
    sigInfo = {};
end

if nargin < 7
    imgName = '';
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


% before and after center between pair of columns
offset = .5;
col_width = .3;

data_min = floor (min (min (data) ) );
data_max = ceil (max( max(data) ) );

% the number of columns has to be even to allow side-by-side
if rem(size(data,2),3)
    return
end
    
%% Create Figure
figure('Units', 'pixels', ...
    'Position', [100 100 800 600]);

hold on;

% boxplot structure
hData_g1 = boxplot(...
    data(:,1:3:end),...
    'BoxStyle'       , 'outline'         , ...
    'Colors'         , [0 0 0 ]          , ...
    'MedianStyle'    , 'line'          , ...
    'Symbol'    , 'ko'          , ...
    'Positions',1-offset:3:size(data,2) ,...
    'Widths', col_width);

% boxplot structure
hData_g2 = boxplot(...
     data(:,2:3:end),...
    'BoxStyle'       , 'outline'         , ...
    'Colors'         , [0 0 0 ]          , ...
    'MedianStyle'    , 'line'          , ...
    'Symbol'    , 'ko'          , ...
    'Positions',1:3:size(data,2) ,...
    'Widths', col_width);

% boxplot structure
hData_g3 = boxplot(...
     data(:,3:3:end),...
    'BoxStyle'       , 'outline'         , ...
    'Colors'         , [0 0 0 ]          , ...
    'MedianStyle'    , 'line'          , ...
    'Symbol'    , 'ko'          , ...
    'Positions',1+offset+.2:3:size(data,2) ,...
    'Widths', col_width);


% patch to color the box plots group1
h = findobj(hData_g1,'Tag','Box');

for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),[.5 .4 .0],'FaceAlpha',.1);
end

% patch to color the box plots group2
h = findobj(hData_g2,'Tag','Box');

for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),[.0 .4 .5],'FaceAlpha',.1);
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
    'YTick'       , data_min:1:data_max, ...
    'YLim'       , [data_min,data_max], ...
    'XLim'       , [-1,size(data,2)], ...
    'XTick'       , 1:3:size(data,2)+1, ...
    'XTickLabel'  , xAxisLabels , ...
    'LineWidth'   , 1           );


if ~isempty (sigInfo)
   sigstar(sigInfo) 
end

if saveImg
     eval( ['print -dpng ' imgName] )
end


end