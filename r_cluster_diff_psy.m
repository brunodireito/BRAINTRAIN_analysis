% Cluster_data
clear,

% add data folder to path
addpath('data')
addpath('functions')

% load psy measures
load data_diff.mat

data_raw = data_diff;


% ------
% var psymeasname - name of the variables available 
% var npsymeas - values of the variables
% ------

%% presets
cluster_num = 2;


%% data preprocessing

% data de-mean and data normalization
data = (data_raw - min(data_raw)) ./ ( max(data_raw) - min(data_raw) );
% find clusters in data
[c_idx,c_means] = kmeans(data,...
    cluster_num,... % number of clusters
    'replicates',5,... % repeats the clustering process starting from different randomly selected centroids for each replicate
    'display', 'iter',... 
    'dist', 'sqeuclidean'); % use euclidean distance to determine best centroid for each point

% display silhouette - value corresponds to fit of each point and distance
% to other class
figure
[silh, ~] = silhouette(data,...
    c_idx,...
    'sqeuclidean');


% disply a 3D plot with cluster
figure
ptsymb = {'bs','r^','md','go','c+'};

for i = 1:cluster_num
    clust = find(c_idx == i);
    plot3(data(clust,1),data(clust,2),data(clust,3),ptsymb{i});
    hold on
end

plot3(c_means(:,1),c_means(:,2),c_means(:,3),'ko');
plot3(c_means(:,1),c_means(:,2),c_means(:,3),'kx');
hold off

view(-137,10);
grid on

%%
eucD = pdist(data,'euclidean');
clustTreeEuc = linkage(eucD,'average');

[h,nodes] = dendrogram(clustTreeEuc,0);
h_gca = gca;
h_gca.TickDir = 'out';
h_gca.TickLength = [.002 0];


%% PCA
[coeff,score,latent,~,explained] = pca(data);

labels = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'};

figure


for i = 1:cluster_num
    clust_i_idxs = find(c_idx == i);
    plot3(score(clust_i_idxs,1),score(clust_i_idxs,2),score(clust_i_idxs,3),ptsymb{i});
    hold on
end

offset = 0.15;
text(score(:,1)+offset,score(:,2)+offset,score(:,3)+offset,labels,'HorizontalAlignment','left');

title('neuropsy');

%%
figure

ptsymb = {'b.','r.'};

for i = 1:cluster_num
    clust_i_idxs = find(c_idx == i);
    plot3( score(clust_i_idxs,1), score(clust_i_idxs,2), score(clust_i_idxs,3), ...
        ptsymb{i},...
        'MarkerSize', 20);
    grid on;
    hold on;
end

offset = 0.15;
text( score(:,1)+offset, score(:,2)+offset, score(:,3)+offset, ...
    labels, ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 12,...
    'FontName', 'Helvetica'...
    );

title('neuropsy');

%% 
mean_val_per_clust = zeros(cluster_num, size(data, 2));

for i = 1:cluster_num
    clust_i_idxs = find(c_idx == i);
    mean_val_per_clust (i, :) = mean(data_raw(clust_i_idxs,:));
end


%%

feat_diff = zeros(1,size(data, 2));
ranksum_diff = zeros(1,size(data, 2));

header_n = cell(0);

for i = 1: size(data, 2)
    [feat_diff(i),~,stats] = ranksum(data(c_idx == 1,i),data(c_idx == 2,i))
    ranksum_diff(i) = stats.ranksum;
    
    header_n{i} = strrep(headers(i), '_',' ') 
end



%% Sorting the variables

[val, idxs] = sort(feat_diff);

idxs_ = idxs(end:-1:1);

figure 

val_ = val (end:-1:1);
barh(val_)

hold on
set(gca,...
    'YTick', 1:25,...
    'YLim', [0.5,25.5],...
    'YTickLabel', header_n(idxs_))

xlabel('p-value, Mann-Whitney between blue a red groups');



line( [0.05, 0.05],[.5, 25.5] ,...
    'Color','r',...
    'LineStyle','--',...
    'LineWidth', 1.5)

