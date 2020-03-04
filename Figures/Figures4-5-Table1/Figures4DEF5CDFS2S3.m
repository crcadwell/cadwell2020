clear all; close all;
load Groups

biConnR = zeros(3,3);
biConnU = zeros(3,3);
biUnconnR = zeros(3,3);
biUnconnU = zeros(3,3);
allR = [];
allU = [];

for i = 1:3
    for j = 1:3
        conn = fetch(mc.Connections & groupR{i,j} & 'conn="connected"');
        connR(i,j) = length(conn);
        for k = 1:length(conn)
            conn2 = fetchn(mc.Connections & ['slice_id="' conn(k).slice_id '"'] ...
                & ['p_column_id=' num2str(conn(k).p_column_id)] ...
                & ['cell_pre="' conn(k).cell_post '"'] ...
                & ['cell_post="' conn(k).cell_pre '"'], 'conn');
            if strcmp(conn2,'connected')
                biConnR(i,j) = biConnR(i,j) + 1;
            elseif ~isempty(conn2)
                biUnconnR(i,j) = biUnconnR(i,j) + 1;
            end
        end
        unconn = fetch(mc.Connections & groupR{i,j} & 'conn="not connected"');
        unconnR(i,j) = length(unconn);
        for k = 1:length(unconn)
            conn2 = fetchn(mc.Connections & ['slice_id="' unconn(k).slice_id '"'] ...
                & ['p_column_id=' num2str(unconn(k).p_column_id)] ...
                & ['cell_pre="' unconn(k).cell_post '"'] ...
                & ['cell_post="' unconn(k).cell_pre '"'], 'conn');
            if strcmp(conn2,'not connected')
                biUnconnR(i,j) = biUnconnR(i,j)+1;
            end
        end
        conn = fetch(mc.Connections & groupU{i,j} & 'conn="connected"');
        connU(i,j) = length(conn);
        for k = 1:length(conn)
            conn2 = fetchn(mc.Connections & ['slice_id="' conn(k).slice_id '"'] ...
                & ['p_column_id=' num2str(conn(k).p_column_id)] ...
                & ['cell_pre="' conn(k).cell_post '"'] ...
                & ['cell_post="' conn(k).cell_pre '"'], 'conn');
            if strcmp(conn2,'connected')
                biConnU(i,j) = biConnU(i,j) + 1;
            elseif ~isempty(conn2)
                biUnconnU(i,j) = biUnconnU(i,j) + 1;
            end
        end
        unconn = fetch(mc.Connections & groupU{i,j} & 'conn="not connected"');
        unconnU(i,j) = length(unconn);
        for k = 1:length(unconn)
            conn2 = fetchn(mc.Connections & ['slice_id="' unconn(k).slice_id '"'] ...
                & ['p_column_id=' num2str(unconn(k).p_column_id)] ...
                & ['cell_pre="' unconn(k).cell_post '"'] ...
                & ['cell_post="' unconn(k).cell_pre '"'], 'conn');
            if strcmp(conn2,'not connected')
                biUnconnU(i,j) = biUnconnU(i,j)+1;
            end
        end
        x = [connR(i,j) unconnR(i,j); connU(i,j) unconnU(i,j)];
        [chi2stat(i,j), pEach(i,j)] = ChiSquared(x);
    end
end
save('allCounts','connR','unconnR','connU','unconnU','biConnR','biConnU','biUnconnR','biUnconnU')

%%
close all;
load allCounts.mat
YR = zeros(1,9);
YU = zeros(1,9);
errR = zeros(9,2);
errU = zeros(9,2);
count = 0;
for i = 1:3
    for j = 1:3
        count = count + 1;
        YR(count) = connR(i,j)/(connR(i,j)+unconnR(i,j));
        YU(count) = connU(i,j)/(connU(i,j)+unconnU(i,j));
        [~,errR(count,:)] = binofit(connR(i,j),(connR(i,j)+unconnR(i,j)));
        errR(count,1) = YR(count) - errR(count,1);
        errR(count,2) = errR(count,2) - YR(count);
        [~,errU(count,:)] = binofit(connU(i,j),(connU(i,j)+unconnU(i,j)));
        errU(count,1) = YU(count) - errU(count,1);
        errU(count,2) = errU(count,2) - YU(count);
    end
end
%% Panel 4D
close all;
Y = [sum(sum(connR))/(sum(sum(connR))+sum(sum(unconnR))) ...
    sum(sum(connU))/(sum(sum(connU))+sum(sum(unconnU))) ...
    sum(sum(biConnR))/(sum(sum(biConnR))+sum(sum(biUnconnR))) ...
    sum(sum(biConnU))/(sum(sum(biConnU))+sum(sum(biUnconnU)))];
for i = 1:4
    if i==1
        [~,errY(i,:)] = binofit(sum(sum(connR)),(sum(sum(connR))+sum(sum(unconnR))));
    elseif i==2
        [~,errY(i,:)] = binofit(sum(sum(connU)),(sum(sum(connU))+sum(sum(unconnU))));
    elseif i==3
        [~,errY(i,:)] = binofit(sum(sum(biConnR))/2,(sum(sum(biConnR))+sum(sum(biUnconnR)))/2);
    elseif i==4
        [~,errY(i,:)] = binofit(sum(sum(biConnU))/2,(sum(sum(biConnU))+sum(sum(biUnconnU)))/2);
    end
    errY(i,1) = Y(i)-errY(i,1);
    errY(i,2) = errY(i,2) - Y(i);
end

figure;
setr = [1 3];
setu = [2 4];
scatter((1:2)-0.1,Y(setr),100,'r','s','filled'); hold on;
errorbar((1:2)-0.1,Y(setr),errY(setr,1),errY(setr,2),'k','Linestyle','none')
scatter((1:2)+0.1,Y(setu),100,'k','s','filled'); hold on;
errorbar((1:2)+0.1,Y(setu),errY(setu,1),errY(setu,2),'k','Linestyle','none')

ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.15];
ax.XTick = [1 2]; ax.XTickLabels = {'Overall','Bidirectional'}; legend(ax.Children([4 2]),{'Related','Unrelated'}); legend('boxoff') 

%% Panel 4E
close all;
connBR = tril(connR,-1)+triu(connR,1);
unconnBR = tril(unconnR,-1)+triu(unconnR,1);
connBU = tril(connU,-1)+triu(connU,1);
unconnBU = tril(unconnU,-1)+triu(unconnU,1);
biConnBR = tril(biConnR,-1)+triu(biConnR,1);
biUnconnBR = tril(biUnconnR,-1)+triu(biUnconnR,1);
biConnBU = tril(biConnU,-1)+triu(biConnU,1);
biUnconnBU = tril(biUnconnU,-1)+triu(biUnconnU,1);

Y = [sum(sum(connBR))/(sum(sum(connBR))+sum(sum(unconnBR))) ...
    sum(sum(connBU))/(sum(sum(connBU))+sum(sum(unconnBU))) ...
    sum(sum(biConnBR))/(sum(sum(biConnBR))+sum(sum(biUnconnBR))) ...
    sum(sum(biConnBU))/(sum(sum(biConnBU))+sum(sum(biUnconnBU)))];
for i = 1:4
    if i==1
        [~,errY(i,:)] = binofit(sum(sum(connBR)),(sum(sum(connBR))+sum(sum(unconnBR))));
    elseif i==2
        [~,errY(i,:)] = binofit(sum(sum(connBU)),(sum(sum(connBU))+sum(sum(unconnBU))));
    elseif i==3
        [~,errY(i,:)] = binofit(sum(sum(biConnBR))/2,(sum(sum(biConnBR))+sum(sum(biUnconnBR)))/2);
    elseif i==4
        [~,errY(i,:)] = binofit(sum(sum(biConnBU))/2,(sum(sum(biConnBU))+sum(sum(biUnconnBU)))/2);
    end
    errY(i,1) = Y(i)-errY(i,1);
    errY(i,2) = errY(i,2) - Y(i);
end

figure;
setr = [1 3];
setu = [2 4];
scatter((1:2)-0.1,Y(setr),100,'r','s','filled'); hold on;
errorbar((1:2)-0.1,Y(setr),errY(setr,1),errY(setr,2),'k','Linestyle','none')
scatter((1:2)+0.1,Y(setu),100,'k','s','filled'); hold on;
errorbar((1:2)+0.1,Y(setu),errY(setu,1),errY(setu,2),'k','Linestyle','none')

ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.1];
ax.XTick = [1 2]; ax.XTickLabels = {'Overall','Bidirectional'}; legend(ax.Children([4 2]),{'Related','Unrelated'}); legend('boxoff') 

%% Panel 4F
close all;
figure;
subplot(2,1,1)
set = [2 4 7];
scatter((1:3)-0.1,YR(set),100,'r','s','filled'); hold on;
errorbar((1:3)-0.1,YR(set),errR(set,1),errR(set,2),'k','Linestyle','none')
scatter((1:3)+0.1,YU(set),100,'k','s','filled'); hold on;
errorbar((1:3)+0.1,YU(set),errU(set,1),errU(set,2),'k','Linestyle','none')
ax = gca; ax.XLim = [0.5 3.5]; ax.YLim = [0 0.3];
ax.XTick = 1:3; ax.XTickLabel = {'2/3-4','4-2/3','5-2/3'};

subplot(2,1,2)
set = [3 6 8];
scatter((1:3)-0.1,YR(set),100,'r','s','filled'); hold on;
errorbar((1:3)-0.1,YR(set),errR(set,1),errR(set,2),'k','Linestyle','none')
scatter((1:3)+0.1,YU(set),100,'k','s','filled'); hold on;
errorbar((1:3)+0.1,YU(set),errU(set,1),errU(set,2),'k','Linestyle','none')
ax = gca; ax.XLim = [0.5 3.5]; ax.YLim = [0 0.3];
ax.XTick = 1:3; ax.XTickLabel = {'2/3-5','4-5','5-4'};

%% Panel 5C
close all;
connWR = diag(connR);
unconnWR = diag(unconnR);
connWU = diag(connU);
unconnWU = diag(unconnU);
biConnWR = diag(biConnR);
biUnconnWR = diag(biUnconnR);
biConnWU = diag(biConnU);
biUnconnWU = diag(biUnconnU);

Y = [sum(sum(connWR))/(sum(sum(connWR))+sum(sum(unconnWR))) ...
    sum(sum(connWU))/(sum(sum(connWU))+sum(sum(unconnWU))) ...
    sum(sum(biConnWR))/(sum(sum(biConnWR))+sum(sum(biUnconnWR))) ...
    sum(sum(biConnWU))/(sum(sum(biConnWU))+sum(sum(biUnconnWU)))];
for i = 1:4
    if i==1
        [~,errY(i,:)] = binofit(sum(sum(connWR)),(sum(sum(connWR))+sum(sum(unconnWR))));
    elseif i==2
        [~,errY(i,:)] = binofit(sum(sum(connWU)),(sum(sum(connWU))+sum(sum(unconnWU))));
    elseif i==3
        [~,errY(i,:)] = binofit(sum(sum(biConnWR))/2,(sum(sum(biConnWR))+sum(sum(biUnconnWR)))/2);
    elseif i==4
        [~,errY(i,:)] = binofit(sum(sum(biConnWU))/2,(sum(sum(biConnWU))+sum(sum(biUnconnWU)))/2);
    end
    errY(i,1) = Y(i)-errY(i,1);
    errY(i,2) = errY(i,2) - Y(i);
end

figure;
setr = [1 3];
setu = [2 4];
scatter((1:2)-0.1,Y(setr),100,'r','s','filled'); hold on;
errorbar((1:2)-0.1,Y(setr),errY(setr,1),errY(setr,2),'k','Linestyle','none')
scatter((1:2)+0.1,Y(setu),100,'k','s','filled'); hold on;
errorbar((1:2)+0.1,Y(setu),errY(setu,1),errY(setu,2),'k','Linestyle','none')

ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.15]; ax.YTick = 0.05:0.05:0.15;
ax.XTick = [1 2]; ax.XTickLabels = {'Overall','Bidirectional'}; legend(ax.Children([4 2]),{'Related','Unrelated'}); legend('boxoff') 
%% Panel 5D
close all;
figure;
set = [1 5 9];
scatter((1:3)-0.1,YR(set),100,'r','s','filled'); hold on;
errorbar((1:3)-0.1,YR(set),errR(set,1),errR(set,2),'k','Linestyle','none')
scatter((1:3)+0.1,YU(set),100,'k','s','filled'); hold on;
errorbar((1:3)+0.1,YU(set),errU(set,1),errU(set,2),'k','Linestyle','none')
ax = gca; ax.XLim = [0.5 3.5]; ax.YLim = [0 0.3];
ax.XTick = 1:3; ax.XTickLabel = {'2/3-2/3','4-4','5-5'};

%% Panel 5F
close all; clear size
load allCounts.mat
for i = 1:3
    for j = 1:3
        [logratio(i,j),ci(i,j,1:2)] = frac_log_ratio_ci(connR(i,j), connR(i,j)+unconnR(i,j), connU(i,j), connU(i,j)+unconnU(i,j));
    end
end
cmap = zeros(300,3);
cmap(end,:) = [237 34 36];
cmap(1,:) = [93 202 233];
for i = 1:size(cmap,1)
    if i<=150
        cmap(i,:) = round(cmap(1,:)*(150-i)/150);
    else
        cmap(i,:) = round(cmap(end,:)*(i-150)/150);
    end
end
cmap = cmap/255;
h = heatmap(logratio,'Colormap',cmap,'ColorLimits',[-2 2]);

%% Figure 5-Supplement 2, Distance-matching
load ResampledData.mat
load TwoSided.mat
clear set; close all

size = 50;
for i = 1:9
    if i==1
        diff_a = diff{i}*length(re_s{i});
        sum_a = length(re_s{i});
        rs_mean_a = rs_mean{i}*length(re_s{i});
        rc_mean_a = rc_mean{i}*length(re_s{i});
    else
        diff_a = diff_a + diff{i}*length(re_s{i});
        sum_a = sum_a + length(re_s{i});
        rs_mean_a = rs_mean_a + rs_mean{i}*length(re_s{i});
        rc_mean_a = rc_mean_a + rc_mean{i}*length(re_s{i});
    end
end
diff_a = diff_a./sum_a;
rs_mean_a = rs_mean_a./sum_a;
rc_mean_a = rc_mean_a./sum_a;

for i = [1 5 9]
    if i==1
        diff_w = diff{i}*length(re_s{i});
        sum_w = length(re_s{i});
        rs_mean_w = rs_mean{i}*length(re_s{i});
        rc_mean_w = rc_mean{i}*length(re_s{i});
    else
        diff_w = diff_w + diff{i}*length(re_s{i});
        sum_w = sum_w + length(re_s{i});
        rs_mean_w = rs_mean_w + rs_mean{i}*length(re_s{i});
        rc_mean_w = rc_mean_w + rc_mean{i}*length(re_s{i});
    end
end
diff_w = diff_w./sum_w;
rs_mean_w = rs_mean_w./sum_w;
rc_mean_w = rc_mean_w./sum_w;

for i = [2 3 4 6 7 8]
    if i==2
        diff_b = diff{i}*length(re_s{i});
        sum_b = length(re_s{i});
        rs_mean_b = rs_mean{i}*length(re_s{i});
        rc_mean_b = rc_mean{i}*length(re_s{i});
    else
        diff_b = diff_b + diff{i}*length(re_s{i});
        sum_b = sum_b + length(re_s{i});
        rs_mean_b = rs_mean_b + rs_mean{i}*length(re_s{i});
        rc_mean_b = rc_mean_b + rc_mean{i}*length(re_s{i});
    end
end
diff_b = diff_b./sum_b;
rs_mean_b = rs_mean_b./sum_b;
rc_mean_b = rc_mean_b./sum_b;

for i = 1:9
    YR(i) = mean(rs_mean{i});
    YU(i) = mean(rc_mean{i});
    rs_mean{i} = sort(rs_mean{i},'ascend');
    rc_mean{i} = sort(rc_mean{i},'ascend');
    ER(i,1) = mean(rs_mean{i}) - rs_mean{i}(25);
    ER(i,2) = rs_mean{i}(975) - mean(rs_mean{i});
    EU(i,1) = mean(rc_mean{i}) - rc_mean{i}(25);
    EU(i,2) = rc_mean{i}(975) - mean(rc_mean{i});
end

Yall = [mean(rs_mean_a) mean(rc_mean_a)];
rs_mean_a = sort(rs_mean_a,'ascend');
rc_mean_a = sort(rc_mean_a,'ascend');
Eall(1,1) = mean(rs_mean_a) - rs_mean_a(25);
Eall(1,2) = rs_mean_a(975) - mean(rs_mean_a);
Eall(2,1) = mean(rc_mean_a) - rc_mean_a(25);
Eall(2,2) = rc_mean_a(975) - mean(rc_mean_a);

YW = [mean(rs_mean_w) mean(rc_mean_w)];
rs_mean_w = sort(rs_mean_w,'ascend');
rc_mean_w = sort(rc_mean_w,'ascend');
EW(1,1) = mean(rs_mean_w) - rs_mean_w(25);
EW(1,2) = rs_mean_w(975) - mean(rs_mean_w);
EW(2,1) = mean(rc_mean_w) - rc_mean_w(25);
EW(2,2) = rc_mean_w(975) - mean(rc_mean_w);

YB = [mean(rs_mean_b) mean(rc_mean_b)];
rs_mean_b = sort(rs_mean_b,'ascend');
rc_mean_b = sort(rc_mean_b,'ascend');
EB(1,1) = mean(rs_mean_b) - rs_mean_b(25);
EB(1,2) = rs_mean_b(975) - mean(rs_mean_b);
EB(2,1) = mean(rc_mean_b) - rc_mean_b(25);
EB(2,2) = rc_mean_b(975) - mean(rc_mean_b);

F = figure('Position',[200 200 500 100]);

X = [1 2];
subplot(1,3,1)
scatter(X,Yall,size,'k','s','filled'); hold on
errorbar (X,Yall,Eall(:,1),Eall(:,2),'linestyle','none','Color','k')
xlim([0.5 2.5])
ylim([0 0.15])
ylabel('Connectivity(%)')
xlabels = {'Related' 'Unrelated'};
yticks = [0:0.05:0.15];
ylabels = {'0' '5' '10' '15'};
set(gca,'Box','off','XTickLabel',xlabels,'Ytick',yticks,'YTickLabel',ylabels);
text(0.6,0.13,['p=' num2str(round(p2_a,3))]);
title('All Connections')

subplot(1,3,2)
scatter(X,YW,size,'k','s','filled'); hold on
errorbar (X,YW,EW(:,1),EW(:,2),'linestyle','none','Color','k')
xlim([0.5 2.5])
ylim([0 0.15])
ylabel('Connectivity(%)')
xlabels = {'Related' 'Unrelated'};
yticks = [0:0.05:0.15];
ylabels = {'0' '5' '10' '15'};
set(gca,'Box','off','XTickLabel',xlabels,'Ytick',yticks,'YTickLabel',ylabels)
text(0.6,0.13,['p=' num2str(round(p2_w,3))]);
title('Within Layers')

subplot(1,3,3)
scatter(X,YB,size,'k','s','filled'); hold on
errorbar (X,YB,EB(:,1),EB(:,2),'linestyle','none','Color','k')
xlim([0.5 2.5])
ylim([0 0.15])
ylabel('Connectivity(%)')
xlabels = {'Related' 'Unrelated'};
yticks = [0:0.05:0.15];
ylabels = {'0' '5' '10' '15'};
set(gca,'Box','off','XTickLabel',xlabels,'Ytick',yticks,'YTickLabel',ylabels)
text(0.6,0.13,['p=' num2str(round(p2_b,3))]);
title('Across Layers')

F = figure('Position',[300 300 500 500]);
layer = {'2/3->2/3' '2/3->4' '2/3->5' '4->2/3' '4->4' '4->5' '5->2/3' '5->4' '5->5'};
for i = 1:9
    subplot(3,3,i)
    Y = [YR(i) YU(i)];
    E = [ER(i,:); EU(i,:)];
    scatter(X,Y,size,'k','s','filled'); hold on
    errorbar(X,Y,E(:,1),E(:,2),'linestyle','none','Color','k')
    xlim([0.5 2.5])
    ylim([0 0.3])
    xlabels = {'Related' 'Unrelated'};
    yticks = [0:0.1:0.3];
    ylabels = {'0' '10' '20' '30'};
    set(gca,'Box','off','YTick',yticks)
    if any(i==[1:3:7])
        set(gca,'YTickLabel',ylabels)
    else
        set(gca,'YTickLabel','')
    end
    if any(i==7:9)
        set(gca,'XTickLabel',xlabels)
    else
        set(gca,'XTickLabel','')
    end
    title(layer{i})
    text(0.6,0.27,['p=' num2str(round(p2(i),3))])
end

%% Figure 5 - Supplement 3, Different rostro-caudal positions

for l = 1:2
    if l==1 
        range = '(1,2,3)';
    elseif l==2
        range = '(4,5)';
    end
    for i = 1:3
        for j = 1:3
            conn = fetch(mc.Connections*mc.PatchColumns & groupR{i,j} & ['location in ' range] & 'conn="connected"');
            connR{l}(i,j) = length(conn);
            unconn = fetch(mc.Connections*mc.PatchColumns & groupR{i,j} & ['location in ' range] & 'conn="not connected"');
            unconnR{l}(i,j) = length(unconn);
            conn = fetch(mc.Connections*mc.PatchColumns & groupU{i,j} & ['location in ' range] & 'conn="connected"');
            connU{l}(i,j) = length(conn);
            unconn = fetch(mc.Connections*mc.PatchColumns & groupU{i,j} & ['location in ' range] & 'conn="not connected"');
            unconnU{l}(i,j) = length(unconn);
        end
    end
    connBR{l} = tril(connR{l},-1)+triu(connR{l},1);
    unconnBR{l} = tril(unconnR{l},-1)+triu(unconnR{l},1);
    connBU{l} = tril(connU{l},-1)+triu(connU{l},1);
    unconnBU{l} = tril(unconnU{l},-1)+triu(unconnU{l},1);
    connWR{l} = diag(connR{l});
    unconnWR{l} = diag(unconnR{l});
    connWU{l} = diag(connU{l});
    unconnWU{l} = diag(unconnU{l});
end

close all; clear YR YU YBR YBU YWR YWU errYR errYU errYBR errYBU errYWR errYWU pAll pB pW
for i = 1:2
    YR(i) = sum(sum(connR{i}))/(sum(sum(connR{i}))+sum(sum(unconnR{i})));
    YU(i) = sum(sum(connU{i}))/(sum(sum(connU{i}))+sum(sum(unconnU{i})));
    YBR(i) = sum(sum(connBR{i}))/(sum(sum(connBR{i}))+sum(sum(unconnBR{i})));
    YBU(i) = sum(sum(connBU{i}))/(sum(sum(connBU{i}))+sum(sum(unconnBU{i})));
    YWR(i) = sum(sum(connWR{i}))/(sum(sum(connWR{i}))+sum(sum(unconnWR{i})));
    YWU(i) = sum(sum(connWU{i}))/(sum(sum(connWU{i}))+sum(sum(unconnWU{i})));
    [~, errYR(i,:)] = binofit(sum(sum(connR{i})), (sum(sum(connR{i}))+sum(sum(unconnR{i}))));
    errYR(i,1) = YR(i)-errYR(i,1);
    errYR(i,2) = errYR(i,2) - YR(i);    
    [~, errYU(i,:)] = binofit(sum(sum(connU{i})), (sum(sum(connU{i}))+sum(sum(unconnU{i}))));
    errYU(i,1) = YU(i)-errYU(i,1);
    errYU(i,2) = errYU(i,2) - YU(i);    
    [~, errYBR(i,:)] = binofit(sum(sum(connBR{i})), (sum(sum(connBR{i}))+sum(sum(unconnBR{i}))));
    errYBR(i,1) = YBR(i)-errYBR(i,1);
    errYBR(i,2) = errYBR(i,2) - YBR(i);    
    [~, errYBU(i,:)] = binofit(sum(sum(connBU{i})), (sum(sum(connBU{i}))+sum(sum(unconnBU{i}))));
    errYBU(i,1) = YBU(i)-errYBU(i,1);
    errYBU(i,2) = errYBU(i,2) - YBU(i);    
    [~, errYWR(i,:)] = binofit(sum(sum(connWR{i})), (sum(sum(connWR{i}))+sum(sum(unconnWR{i}))));
    errYWR(i,1) = YWR(i)-errYWR(i,1);
    errYWR(i,2) = errYWR(i,2) - YWR(i);    
    [~, errYWU(i,:)] = binofit(sum(sum(connWU{i})), (sum(sum(connWU{i}))+sum(sum(unconnWU{i}))));
    errYWU(i,1) = YWU(i)-errYWU(i,1);
    errYWU(i,2) = errYWU(i,2) - YWU(i);
    [~, pAll(i)] = fishertest([sum(sum(connR{i})),sum(sum(unconnR{i})); sum(sum(connU{i})), sum(sum(unconnU{i}))]);
    [~, pB(i)] = fishertest([sum(sum(connBR{i})),sum(sum(unconnBR{i})); sum(sum(connBU{i})), sum(sum(unconnBU{i}))]);
    [~, pW(i)] = fishertest([sum(sum(connWR{i})),sum(sum(unconnWR{i})); sum(sum(connWU{i})), sum(sum(unconnWU{i}))]);
end

close all; figure;
X = 1:2;

subplot(3,1,1)
scatter(X+0.1,YU,100,'k','.'); hold on;
errorbar(X+0.1,YU,errYU(:,1),errYU(:,2),'k','Linestyle','none')
scatter(X-0.1,YR,100,'r','.');
errorbar(X-0.1,YR,errYR(:,1),errYR(:,2),'k','Linestyle','none')
for i = 1:2
    text(X(i),max([YR(i)+errYR(i,2) YU(i)+errYU(i,2)])+0.02, ['p=' num2str(round(pAll(i),2))],'HorizontalAlignment','center');
end
ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.2]; ax.YTick = 0.05:0.05:0.2;
ax.XTick = 1:2; legend(ax.Children([4 6]),{'Related','Unrelated'}); legend('boxoff') 
title ('All connections')
ylabel('Connection Probability')

subplot(3,1,2)
scatter(X+0.1,YBU,100,'k','.'); hold on;
errorbar(X+0.1,YBU,errYBU(:,1),errYBU(:,2),'k','Linestyle','none')
scatter(X-0.1,YBR,100,'r','.');
errorbar(X-0.1,YBR,errYBR(:,1),errYBR(:,2),'k','Linestyle','none')
for i = 1:2
    text(X(i),max([YBR(i)+errYBR(i,2) YBU(i)+errYBU(i,2)])+0.02, ['p=' num2str(round(pB(i),2))],'HorizontalAlignment','center');
end
ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.2]; ax.YTick = 0.05:0.05:0.2;
ax.XTick = 1:2; legend(ax.Children([4 6]),{'Related','Unrelated'}); legend('boxoff') 
title('Vertical connections')
ylabel('Connection Probability')

subplot(3,1,3)
scatter(X+0.1,YWU,100,'k','.'); hold on;
errorbar(X+0.1,YWU,errYWU(:,1),errYWU(:,2),'k','Linestyle','none')
scatter(X-0.1,YWR,100,'r','.');
errorbar(X-0.1,YWR,errYWR(:,1),errYWR(:,2),'k','Linestyle','none')
for i = 1:2
    text(X(i),max([YWR(i)+errYWR(i,2) YWU(i)+errYWU(i,2)])+0.02, ['p=' num2str(round(pW(i),2))],'HorizontalAlignment','center');
end
ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.2]; ax.YTick = 0.05:0.05:0.2;
ax.XTick = 1:2; legend(ax.Children([4 6]),{'Related','Unrelated'}); legend('boxoff') 
title('Lateral connections')
xlabel('Rostrocaudal position (1 is most rostral)')
ylabel('Connection Probability')


%% Table 1 - GLM of connection probability

count = 0;
conn = [];
connType = [];
dist = [];
loc = [];
rel = [];

for i = 1:3
    for j = 1:3
        for k = 1:length(groupR{i,j})
            count = count + 1;
            conn(count) = strcmp(fetchn(mc.Connections & groupR{i,j}(k),'conn'),'connected');
            pre = fetchn(mc.PatchCells & groupR{i,j}(k) & ['p_cell_id="' groupR{i,j}(k).cell_pre '"'],'layer');
            post = fetchn(mc.PatchCells & groupR{i,j}(k) & ['p_cell_id="' groupR{i,j}(k).cell_post '"'],'layer');
            connType(count) = ~strcmp(pre,post);
            dist(count) = fetchn(mc.Distances & groupR{i,j}(k),'euc_dist');
            l = fetchn(mc.PatchColumns & groupR{i,j}(k),'location');
            try 
                loc(count) = str2num(l{1});
            catch
                continue
            end
            rel(count) = 1;
        end
        for k = 1:length(groupU{i,j})
            count = count + 1;
            conn(count) = strcmp(fetchn(mc.Connections & groupU{i,j}(k),'conn'),'connected');
            pre = fetchn(mc.PatchCells & groupU{i,j}(k) & ['p_cell_id="' groupU{i,j}(k).cell_pre '"'],'layer');
            post = fetchn(mc.PatchCells & groupU{i,j}(k) & ['p_cell_id="' groupU{i,j}(k).cell_post '"'],'layer');
            connType(count) = ~strcmp(pre,post);
            dist(count) = fetchn(mc.Distances & groupU{i,j}(k),'euc_dist');
            l = fetchn(mc.PatchColumns & groupU{i,j}(k),'location');
            try 
                loc(count) = str2num(l{1});
            catch
                continue
            end
            rel(count) = 0;
        end
    end
end

T = table(rel', connType', dist', loc', conn','VariableNames',{'lineage','ConnectionClass','EuclideanDistance','Location','Connection'});
glm = fitglm(T,'interactions','Distribution','binomial','Link','logit','Exclude',loc==0)
save('GLM Analysis','T','glm','loc');

%% Generate source data file

count = 0;
for i = 1:3
    for j = 1:3
        for l = 1:length(groupR{i,j})
            count = count + 1;
            c = groupR{i,j}(l);
            mouseID(count) = c.animal_id;
            sliceID{count} = c.slice_id;
            columnID(count) = c.p_column_id;
            preCellID{count} = c.cell_pre;
            preCell = fetch(mc.PatchCells & c & ['p_cell_id="' c.cell_pre '"'],'*');
            preCellLayer{count} = preCell.layer;
            preCellLabel{count} = preCell.label;
            preCellFP{count} = preCell.fp;
            preCellMorph{count} = preCell.morph;
            postCellID{count} = c.cell_post;
            postCell = fetch(mc.PatchCells & c & ['p_cell_id="' c.cell_post '"'],'*');
            postCellLayer{count} = postCell.layer;
            postCellLabel{count} = postCell.label;
            postCellFP{count} = postCell.fp;
            postCellMorph{count} = postCell.morph;
            dist = fetch(mc.Distances & c,'*');
            tangDist(count) = dist.tang_dist;
            vertDist(count) = dist.vert_dist;
            eucDist(count) = dist.euc_dist;
        end
        for l = 1:length(groupU{i,j})
            count = count + 1;
            c = groupU{i,j}(l);
            mouseID(count) = c.animal_id;
            sliceID{count} = c.slice_id;
            columnID(count) = c.p_column_id;
            preCellID{count} = c.cell_pre;
            preCell = fetch(mc.PatchCells & c & ['p_cell_id="' c.cell_pre '"'],'*');
            preCellLayer{count} = preCell.layer;
            preCellLabel{count} = preCell.label;
            preCellFP{count} = preCell.fp;
            preCellMorph{count} = preCell.morph;
            postCellID{count} = c.cell_post;
            postCell = fetch(mc.PatchCells & c & ['p_cell_id="' c.cell_post '"'],'*');
            postCellLayer{count} = postCell.layer;
            postCellLabel{count} = postCell.label;
            postCellFP{count} = postCell.fp;
            postCellMorph{count} = postCell.morph;
            dist = fetch(mc.Distances & c,'*');
            tangDist(count) = dist.tang_dist;
            vertDist(count) = dist.vert_dist;
            eucDist(count) = dist.euc_dist;
        end
    end
end
t = table(mouseID', sliceID', columnID', preCellID', preCellLayer', preCellLabel',...
    preCellFP', preCellMorph', postCellID', postCellLayer', postCellLabel', postCellFP',...
    postCellMorph', tangDist', vertDist', eucDist');

writetable(t,'Connections Source Data.xlsx')