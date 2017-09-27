% Cluster_data
clear,

load psymeasdata.mat

%%
temp = npsymeas(:,1:20);
data = (temp - min(temp)) ./ ( max(temp) - min(temp) )

[cidx2,cmeans2] = kmeans(data,2,'replicates',5,'display', 'iter');

figure
[silh2,h] = silhouette(data,cidx2,'sqeuclidean');

figure
ptsymb = {'bs','r^','md','go','c+'};
for i = 1:2
    clust = find(cidx2==i);
    plot3(data(clust,1),data(clust,2),data(clust,3),ptsymb{i});
    hold on
end

plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'ko');
plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'kx');
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
