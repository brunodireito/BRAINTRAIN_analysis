%% results cluster for the combination of neuroimaging data and neuropsychological
% Script combines two sources of data and appplies a cluistering technique
% Requires -

% Version 1.0
% - Overall restructure

% Author: Bruno Direito (2018)

%% Configuration and presets
clear,

% add data folder to path
addpath('data')
addpath('helpers')

% load roiglm measures
load psc.mat

% load psy measures
load psymeasdata.mat

% headers
headers_psc = createPSCHeaders();
headers_psymeas = psymeasname;
% combine headers from both datasets
headers = [headers_psc headers_psymeas];

% data
data_raw_psy = npsymeas;
data_raw_psc = psc;

% ------
% var psymeasname - name of the variables available 
% var npsymeas - values of the variables
% ------

%% data preprocessing

% reshape (concatenate ever session per patient)
data_raw_t = [];

for p = 1:15
    data_raw_l = [];
    
    for s = 1:5
        data_raw_l = [data_raw_l data_raw_psc( ((p-1)*5) + s, :)];
    end
    data_raw_t(p,:) = data_raw_l;
end
data_raw = data_raw_t;

% concat with psy measures
data_raw = [data_raw data_raw_psy];


% data de-mean and data normalization
for m = 1:size(data_raw, 2)
    data(:, m) = (data_raw(:, m) - min(data_raw(:, m))) ./ ( max(data_raw(:, m)) - min(data_raw(:, m)) );
end

%% presets
cluster_num = 2;


%% clustering

% find clusters in data
[c_idx,c_means] = kmeans(data,...
    cluster_num,... % number of clusters
    'replicates', 10,... % repeats the clustering process starting from different randomly selected centroids for each replicate
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
figure
eucD = pdist(data,'euclidean');
clustTreeEuc = linkage(eucD,'average');

[h,nodes] = dendrogram(clustTreeEuc,0);
h_gca = gca;
h_gca.TickDir = 'out';
h_gca.TickLength = [.002 0];


%% Classical MDS

dissimilarities = pdist(data,'euclidean');

[Y,e] = cmdscale(dissimilarities);

labels = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'};

figure, 
grid 
for i = 1:cluster_num
    clust_i_idxs = find(c_idx == i);
    plot3(Y(clust_i_idxs,1),Y(clust_i_idxs,2),Y(clust_i_idxs,3),ptsymb{i});
    hold on
end

offset = 0.15;
text(Y(:,1)+offset,Y(:,2)+offset,Y(:,3)+offset,labels,'HorizontalAlignment','left');%% Classical MDS


%% PCA
[coeff,score,latent,~,explained] = pca(data);

labels = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'};

figure
title('combine')

for i = 1:cluster_num
    clust_i_idxs = find(c_idx == i);
    plot3(score(clust_i_idxs,1),score(clust_i_idxs,2),score(clust_i_idxs,3),ptsymb{i});
    hold on
end

offset = 0.15;
text(score(:,1)+offset,score(:,2)+offset,score(:,3)+offset,labels,'HorizontalAlignment','left');

%%
headers_cell = arrayfun(@(x)char(headers(x)),1:numel(headers),'uni',false)

%%
figure, 
biplot(coeff(:,1:3),'scores',score(:,1:3), 'varlabels', headers_cell );

%% 
mean_val_per_clust = zeros(cluster_num, size(data, 2));

for i = 1:cluster_num
    clust_i_idxs = find(c_idx == i);
    mean_val_per_clust (i, :) = mean(data_raw(clust_i_idxs,:));
end
