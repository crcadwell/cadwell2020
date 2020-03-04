% Insert new data into table
cd /Users/cathryn/Dropbox/'Microcolumn Paper'/'Neuron version 2018'/Revision1/'New Clone Quantification Data'/

clear all; close all;
count = 0;
mouse_count = 0;
a = fetch(mc.QuantExp & 'sac_time="P10"');
moms = unique([a.animal_id]);
for i = 1:length(moms)
    pups = fetchn(mc.QuantExp & ['animal_id=' num2str(moms(i))],'pup_id');
    for j = 1:length(pups)
        mouse_count = mouse_count + 1;
        clones = unique(fetchn(mc.QuantClones & ['animal_id=' num2str(moms(i))] & ['pup_id=' num2str(pups(j))],'clone_id'));
        for k = 1:length(clones)
            count = count+1;
            tx(count) = fetchn(mc.QuantExp & ['animal_id=' num2str(moms(i))] & ['pup_id=' num2str(pups(j))],'tx_time');
            width(count) = median(fetchn(mc.QuantClones & ['animal_id=' num2str(moms(i))] & ['pup_id=' num2str(pups(j))] & ['clone_id=' num2str(clones(k))],'width'));
            ncells(count) = sum(fetchn(mc.QuantClones & ['animal_id=' num2str(moms(i))] & ['pup_id=' num2str(pups(j))] & ['clone_id=' num2str(clones(k))],'cell_count'));
            mouse(count) = mouse_count;
        end
    end
end
save('CloneQuantification','tx','ncells','width','mouse')

%% Panel 1D-F
clear all; close all; load 'CloneQuantification.mat'

X = zeros(1,length(tx));
X(find(strcmp(tx,'E9.5'))) = 1;
X(find(strcmp(tx,'E10.5'))) = 2;
X(find(strcmp(tx,'E11.5'))) = 3;

jitteramount = 0.1;

close all; 
figure;
subplot(1,3,1)
Y = ncells;
jittervalues = 2*(rand(size(Y))-0.5)*jitteramount;
scatter(X+jittervalues,Y,50,'k','filled')
ax = gca; ax.YScale = 'log'; ax.XLim = [0.5 3.5]; 
ax.XTick = 1:3; ax.XTickLabel = {'E9.5','E10.5','E11.5'};
ax.YLim = [0 10^4];
p(1,1) = ranksum(ncells(find(X==1)),ncells(find(X==2)));
p(1,2) = ranksum(ncells(find(X==2)),ncells(find(X==3)));

subplot(1,3,2)
Y = width;
jittervalues = 2*(rand(size(Y))-0.5)*jitteramount;
scatter(X+jittervalues,Y,50,'k','filled')
ax = gca; ax.XLim = [0.5 3.5]; 
ax.XTick = 1:3; ax.XTickLabel = {'E9.5','E10.5','E11.5'};
ax.YLim = [0 800];
p(2,1) = ranksum(width(find(X==1)),width(find(X==2)));
p(2,2) = ranksum(width(find(X==2)),width(find(X==3)));

subplot(1,3,3)
X = 1:3;
Y1 = [0 1 10];
Y2 = [21 39 50];
Y = Y1./Y2;
for i = 1:3
    [~,errY(i,:)] = binofit(Y1(i), Y2(i));
    errY(i,1) = Y(i) - errY(i,1);
    errY(i,2) = errY(i,2) - Y(i);
end
scatter(X,Y,50,'k','filled'); hold on;
errorbar(X,Y,errY(:,1),errY(:,2),'k','LineStyle','none');
ax = gca; ax.XLim = [0.5 3.5]; 
ax.XTick = 1:3; ax.XTickLabel = {'E9.5','E10.5','E11.5'};
ax.YLim = [0 0.5];
[~,p(3,1)] = fishertest([Y1(1) Y2(1)-Y1(1); Y1(2) Y2(2)-Y1(2)]);
[~,p(3,2)] = fishertest([Y1(2) Y2(2)-Y1(2); Y1(3) Y2(3)-Y1(3)]);

p

%% Figure 1 Supplement 1
close all; clear p
incompSizes = [14 22 22 23 26 39 34 15 21 39];
incompWidth = [113 195 272.5 304 296 177 141 120 230 230];

compSizes = ncells(find(strcmp(tx,'E11.5')));
compSizes = [setdiff(compSizes,incompSizes) 26 39 39];
compWidth = width(find(strcmp(tx,'E11.5')));
compWidth = [setdiff(compWidth,incompWidth) 177 141];

jitteramount = 0.1;

figure;
subplot(1,2,1)
X = []; X(1:length(compSizes)) = 1; X(end+1:end+length(incompSizes)) = 2;
Y = [compSizes incompSizes];
jittervalues = 2*(rand(size(Y))-0.5)*jitteramount;
scatter(X+jittervalues,Y,30,'k','filled')
ax = gca; ax.XLim = [0.5 2.5];ax.YLim = [0 150];
p(1) = ranksum(compSizes, incompSizes);

subplot(1,2,2)
X = []; X(1:length(compWidth)) = 1; X(end+1:end+length(incompWidth)) = 2;
Y = [compWidth incompWidth];
jittervalues = 2*(rand(size(Y))-0.5)*jitteramount;
scatter(X+jittervalues,Y,30,'k','filled')
ax = gca; ax.XLim = [0.5 2.5];ax.YLim = [0 500];
p(2) = ranksum(compWidth, incompWidth);

p

%% Figure 1 Panels I and J
clear all; close all;

E12NRG = [4 4 4 1 2 1 2 3 2 2 2 2 3 1 4 2 4 1 1 2 4 4 4 4 1 2 3 2 3 2];
E12NCol = [1 1 1 1 1 1 1 2 1 1 1 1 2 1 2 1 2 1 1 1 2 1 1 1 2 1 1 1 1 1];
E12Sub = [1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3];

E14NRG = [4 6 4 1 1 2 2 3];
E14NCol = [3 2 2 1 1 2 1 2];
E14Sub = [1 1 1 2 2 2 2 3];

close all; 
figure('Position',[100 300 200 100]); 

Y = zeros(max(E12NRG),max(E12Sub));
for i = 1:max(E12NRG)
    for j = 1:max(E12Sub)
        Y(i,j) = length(find(E12NRG==i & E12Sub==j));
    end
end
subplot(1,2,1)
bar(Y,'stacked'); ylim([0 15])
ax = gca; ax.Box = 'off';

Y = zeros(max(E12NCol),max(E12Sub));
for i = 1:max(E12NCol)
    for j = 1:max(E12Sub)
        Y(i,j) = length(find(E12NCol==i & E12Sub==j));
    end
end
subplot(1,2,2)
bar(Y,'stacked'); ylim([0 30])
ax = gca; ax.Box = 'off';
