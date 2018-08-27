% Cluster_data
clear,

% add data folder to path
addpath('data')
addpath('functions')

% load roiglm - % signal change measures
load psc.mat

data_raw = psc;

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
        data_raw_l = [data_raw_l data_raw( ((p-1)*5) + s, :)];
    end
    data_raw_t(p,:) = data_raw_l;
end
data_raw = data_raw_t;

% data de-mean and data normalization
data = (data_raw - min(data_raw)) ./ ( max(data_raw) - min(data_raw) );



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

title('roiglm')

%% 
mean_val_per_clust = zeros(cluster_num, 25);

for i = 1:cluster_num
    clust_i_idxs = find(c_idx == i);
    mean_val_per_clust (i, :) = mean(data_raw_t(clust_i_idxs,:));
end

%% headers

headers_psc_per_session = {};

sessions_label = {'s1', 's2', 's3', 's4', 's5'};
runs_label = {'loc', 'train', 'nf1', 'nf2', 'trans'};

idx = 1;
for i = 1:numel(sessions_label)
    for j = 1:numel(runs_label)
        headers_psc_per_session(idx) = {[sessions_label{i} '_' runs_label{j}]};
        idx = idx +1;
    end
end
