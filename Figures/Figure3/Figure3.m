clear all; close all;
load data.mat

%%
cProj = [];
for i = 1:length(sample)
    c = find(strcmp(projectionCells,sample{i}));
    cProj(i,:) = columnProjection(c,:);
end

save('columnProjection','cProj')
%%
for i = 1:length(sample)
    c = find(strcmp(classCells,sample{i}));
    class{i} = clust{c};
    classID(i) = clustID(c);
end
save('classAssignments','class','classID')
%%
hexColor = allentsneColor; clear allentsneColor
for i = 1: length(hexColor)
    allentsneColor(i,:) = hex2rgb(hexColor{i});
end

save('allenData','allentsne','allentsneNames','allentsneColor')
%%
clear all
load columnProjection.mat 
load classAssignments.mat
load data.mat
load allenData.mat
pos = find(strcmp(label,'positive'));
neg = find(strcmp(label,'negative'));
    
%%  Figure 3A t-SNE by layer (modified colors for L2/3 and L4 in Illustrator) and added cluster labels
close all;
figure('Position',[500 500 500 500]); scatter(allentsne(:,1),allentsne(:,2),5,allentsneColor,'filled'); hold on
map = [0 0 0; 1 0 0; 1 0 1; 0 0 1];
for i = 1:size(cProj,1)
    if cProj(i,3) <= 5
        s(i) = 30;
    elseif cProj(i,3) <=10
        s(i) = 20;
    else s(i) = 10;
    end
end
scatter(cProj(find(strcmp(layer,'2/3')),1),cProj(find(strcmp(layer,'2/3')),2),s(find(strcmp(layer,'2/3'))),map(1,:),'filled','MarkerEdgeColor','k');
scatter(cProj(find(strcmp(layer,'4')),1),cProj(find(strcmp(layer,'4')),2),s(find(strcmp(layer,'4'))),map(2,:),'filled','MarkerEdgeColor','k');
scatter(cProj(find(strcmp(layer,'5')),1),cProj(find(strcmp(layer,'5')),2),s(find(strcmp(layer,'5'))),map(3,:),'filled','MarkerEdgeColor','k');
scatter(cProj(find(strcmp(layer,'6')),1),cProj(find(strcmp(layer,'6')),2),s(find(strcmp(layer,'6'))),map(4,:),'filled','MarkerEdgeColor','k');
ax = gca;lgd = legend([ax.Children(4) ax.Children(3) ax.Children(2) ax.Children(1)],'L2/3','L4','L5','L6'); lgd.Box = 'off';
ax.Position = [0.12 0.12 0.75 0.75]; %ax.XGrid = 'on'; ax.YGrid = 'on';

%% Visualize cluster labels
for i = 1:length(unique(allentsne(:,3)))
    s = find(allentsne(:,3)==i);
    X = mean(allentsne(s,1));
    Y = mean(allentsne(s,2));
    text(X,Y,allentsneNames{s(1)})
end
%% Figure 3 Supplement 1 panel A t-SNE by label
close all;
figure('Position',[500 500 500 500]); scatter(allentsne(:,1),allentsne(:,2),5,allentsneColor,'filled'); hold on
scatter(cProj(neg,1),cProj(neg,2),s(neg),'k','filled','MarkerEdgeColor','k');
scatter(cProj(pos,1),cProj(pos,2),s(pos),'r','filled','MarkerEdgeColor','k');
ax = gca;lgd = legend([ax.Children(2) ax.Children(1)],'neg','pos'); lgd.Box = 'off';
ax.Position = [0.12 0.12 0.75 0.75];

%%  Figure 3 Supplement 2
close all; figure('Position',[500 500 500 500]);
for i = 1:max(clone)
    subplot(4,4,i)
    scatter(allentsne(:,1),allentsne(:,2),5,[0.5 0.5 0.5],'filled'); hold on
    hold on
    xlim([-100 80])
    ylim([-80 100])
    set = find(clone==i);
    scatter(cProj(intersect(neg,set),1),cProj(intersect(neg,set),2),20,'k','filled');
    scatter(cProj(intersect(pos,set),1),cProj(intersect(pos,set),2),20,'r','filled');
    ax = gca;
    ax.Visible = 'off';
    ax.Position(3:4) = [0.2 0.2];
end
%print -depsc -tiff -r300 -painters TSNEbyLabelEachClone.eps

%%  Figure 3 Supplement 1 panel B Mapping to broad classes
clear count nclass nposClass nnegClass chi2stat p pcorr nposErr nnegErr broadClass
classes = {'Interneurons','L5 PT','L5 IT','L6 IT','L2/3 IT','L4 IT','L6b','L6 CT','L5/6 NP','Non-neuronal'};
for i = 1: length(class)
    if strncmp(class(i),'L2/3 IT',7)
        broadClass{i} = 'L2/3 IT';
    elseif strncmp(class(i),'L4 IT',5)
        broadClass{i} = 'L4 IT';
    elseif strncmp(class(i),'L5 IT',5)
        broadClass{i} = 'L5 IT';
    elseif strncmp(class(i),'L5 NP',5) | strncmp(class(i),'L6 NP',5)
        broadClass{i} = 'L5/6 NP';
    elseif strncmp(class(i),'L5 PT',5)
        broadClass{i} = 'L5 PT';
    elseif strncmp(class(i),'L6 CT',5)
        broadClass{i} = 'L6 CT';
    elseif strncmp(class(i),'L6 IT',5)
        broadClass{i} = 'L6 IT';
    elseif strncmp(class(i),'L6b',3)
        broadClass{i} = 'L6b';
    elseif strncmp(class(i),'Oligo',5)
        broadClass{i} = 'Non-neuronal';
    else broadClass{i} = 'Interneurons';
    end
end
count = 0;
for i = 1:length(classes)
    if length(find(strcmp(broadClass,classes{i})))>=3
        count = count + 1;
        nclass{count} = classes{i};
        nposClass(count) = length(intersect(pos,find(strcmp(broadClass,classes{i}))))/length(pos);
        nnegClass(count) = length(intersect(neg,find(strcmp(broadClass,classes{i}))))/length(neg);
        [~,nposErr(count,:)] = binofit(nposClass(count)*length(pos),length(pos));
        [~,nnegErr(count,:)] = binofit(nnegClass(count)*length(neg),length(neg));
    end
end
close all; figure;
scatter(1:3:(3*length(nnegClass)), nnegClass,[],'k','s','filled'); hold on
scatter(2:3:(3*length(nposClass)+1), nposClass,[],'r','s','filled');
errorbar(1:3:(3*length(nnegClass)), nnegClass, nnegClass - nnegErr(:,1)', nnegErr(:,2)' - nnegClass,'k','LineStyle','none');
errorbar(2:3:(3*length(nposClass)+1),nposClass, nposClass - nposErr(:,1)', nposErr(:,2)' - nposClass,'k','LineStyle','none');
ax = gca; ax.XTick = 1.5:3:3*length(nclass)+2; ax.XTickLabel = nclass; ax.XTickLabelRotation = 60; 
ax.Box = 'off'; 
xlim([0 3*length(nclass)])
ylim([0 0.5])
legend({'unlabeled','labeled'}); legend('boxoff')
ylabel('Fraction of cells')
[chi2stat,p] = ChiSquared([nposClass*length(pos); nnegClass*length(neg)])
%chi2stat =    6.4250
%p =    0.3773

%%  Figure 3 - Supplement 1 panel C probability same broad class, across all layers
close all
clear setpos setneg simpos simneg npos nneg err
count = 0;
for i = 1:max(clone)
    setpos = intersect(pos,find(clone==i));
    if length(setpos)>=0
        setneg = intersect(neg,find(clone==i));
        if length(setneg)>=0
            count = count + 1;
            simpos(count) = length(setpos) - length(unique(broadClass(setpos)));
            simneg(count) = length(setneg) - length(unique(broadClass(setneg)));
            npos(count) = (length(setpos)*(length(setpos)-1))/2;
            nneg(count) = (length(setneg)*(length(setneg)-1))/2;
        end
    end
end
clear count
sum(simpos)/sum(npos) % 43/337, 12.76%
sum(simneg)/sum(nneg) % 56/409, 13.69%
[chi2stat,p] = ChiSquared([sum(simpos) sum(npos)-sum(simpos); sum(simneg) sum(nneg)-sum(simneg)])
%chi2stat = 0.1395
%p = 0.7088

Y = [sum(simpos)/sum(npos) sum(simneg)/sum(nneg)];
[~,err(1,:)] = binofit(sum(simpos),sum(npos));
[~,err(2,:)] = binofit(sum(simneg),sum(nneg));
scatter(1:2,Y,[],'k','s','filled'); hold on;
errorbar(1:2, Y, Y-err(:,1)',err(:,2)'-Y,'k','LineStyle','none');
ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.2];
ax.YTick = 0:0.1:0.2; ax.XTick = [1 2]; ax.XTickLabel = {'Related','Unrelated'};
ax.Box = 'off'; 

%% Figure 3 - Supplement 1 panel D probability same broad class, controlling for layer position
close all
clear setpos setneg simpos simneg npos nneg err
count = 0;
layers = unique(layer);
for i = 1:max(clone)
    for j = 1:length(layers)
        setpos = intersect(pos,find(clone==i));
        setpos = intersect(setpos,find(strcmp(layer,layers{j})));
        if length(setpos)>=2
            setneg = intersect(neg,find(clone==i));
            setneg = intersect(setneg,find(strcmp(layer,layers{j})));
            if length(setneg)>=0
                count = count + 1;
                simpos(count) = length(setpos) - length(unique(broadClass(setpos)));
                simneg(count) = length(setneg) - length(unique(broadClass(setneg)));
                npos(count) = (length(setpos)*(length(setpos)-1))/2;
                nneg(count) = (length(setneg)*(length(setneg)-1))/2;
            end
        end
    end
end
clear count
sum(simpos)/sum(npos) % 36/154, 23.38%
sum(simneg)/sum(nneg) % 39/157, 24.84%
[chi2stat,p] = ChiSquared([sum(simpos) sum(npos)-sum(simpos); sum(simneg) sum(nneg)-sum(simneg)])
%chi2stat = 0.0911
%p = 0.7628

Y = [sum(simpos)/sum(npos) sum(simneg)/sum(nneg)];
[~,err(1,:)] = binofit(sum(simpos),sum(npos));
[~,err(2,:)] = binofit(sum(simneg),sum(nneg));
scatter(1:2,Y,[],'k','s','filled'); hold on;
errorbar(1:2, Y, Y-err(:,1)',err(:,2)'-Y,'k','LineStyle','none');
ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.4];
ax.YTick = 0:0.1:0.4; ax.XTick = [1 2]; ax.XTickLabel = {'Related','Unrelated'};
ax.Box = 'off'; 

%%  Figure 3 panel B, mapping to final leaflets 
clear count nclass nposClass nnegClass chi2stat p pcorr nposErr nnegErr 
classes = unique(class);
count = 0;
for i = 1:length(classes)
    if length(find(strcmp(class,classes{i})))>=3
        count = count + 1;
        nclass{count} = classes{i};
        nposClass(count) = length(intersect(pos,find(strcmp(class,classes{i}))))/length(pos);
        nnegClass(count) = length(intersect(neg,find(strcmp(class,classes{i}))))/length(neg);
        [~,nposErr(count,:)] = binofit(nposClass(count)*length(pos),length(pos));
        [~,nnegErr(count,:)] = binofit(nnegClass(count)*length(neg),length(neg));
    end
end
close all; figure;
scatter(1:3:(3*length(nnegClass)), nnegClass,[],'k','s','filled'); hold on
scatter(2:3:(3*length(nposClass)+1), nposClass,[],'r','s','filled');
errorbar(1:3:(3*length(nnegClass)), nnegClass, nnegClass - nnegErr(:,1)', nnegErr(:,2)' - nnegClass,'k','LineStyle','none');
errorbar(2:3:(3*length(nposClass)+1),nposClass, nposClass - nposErr(:,1)', nposErr(:,2)' - nposClass,'k','LineStyle','none');
ax = gca; ax.XTick = 1.5:3:3*length(nclass)+2; ax.XTickLabel = nclass; ax.XTickLabelRotation = 60; 
ax.Box = 'off'; 
xlim([0 3*length(nclass)])
ylim([0 0.5])
legend({'unlabeled','labeled'}); legend('boxoff')
ylabel('Fraction of cells')
[chi2stat,p] = ChiSquared([nposClass*length(pos); nnegClass*length(neg)])
%chi2stat =    21.8805
%p =    0.0389
for i = 1:count
    [chi2statEach(i),pEach(i)] = ChiSquared([nposClass(i)*length(pos) length(pos)-nposClass(i)*length(pos); nnegClass(i)*length(neg) length(neg)-nnegClass(i)*length(neg)]);
    pEach(i) = pEach(i)*count; % Bonferroni correction
end

pEach
%  Columns 1 through 5
%    7.3293    8.8406    0.0225    5.3759    7.5646
%  Columns 6 through 10
%    7.4033    4.2974    2.0443    1.6852    2.9558
%  Columns 11 through 13
%    3.2531    1.7394    2.3444
%% Figure 3 panel C, probability same final leaflet, overall
close all
clear setpos setneg simpos simneg npos nneg err
count = 0;
for i = 1:max(clone)
    setpos = intersect(pos,find(clone==i));
    if length(setpos)>=0
        setneg = intersect(neg,find(clone==i));
        if length(setneg)>=0
            count = count + 1;
            simpos(count) = length(setpos) - length(unique(class(setpos)));
            simneg(count) = length(setneg) - length(unique(class(setneg)));
            npos(count) = (length(setpos)*(length(setpos)-1))/2;
            nneg(count) = (length(setneg)*(length(setneg)-1))/2;
        end
    end
end
clear count
sum(simpos)/sum(npos) % 27/337, 8.01%
sum(simneg)/sum(nneg) % 36/409, 8.80%
[chi2stat,p] = ChiSquared([sum(simpos) sum(npos)-sum(simpos); sum(simneg) sum(nneg)-sum(simneg)])
%chi2stat = 0.1492
%p = 0.6993

Y = [sum(simpos)/sum(npos) sum(simneg)/sum(nneg)];
[~,err(1,:)] = binofit(sum(simpos),sum(npos));
[~,err(2,:)] = binofit(sum(simneg),sum(nneg));
scatter(1:2,Y,[],'k','s','filled'); hold on;
errorbar(1:2, Y, Y-err(:,1)',err(:,2)'-Y,'k','LineStyle','none');
ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.2];
ax.YTick = 0:0.1:0.2; ax.XTick = [1 2]; ax.XTickLabel = {'Related','Unrelated'};
ax.Box = 'off';

%% Figure 3 panel D, probability same final leaf, controlling for layer position
close all
clear setpos setneg simpos simneg npos nneg err
count = 0;
layers = unique(layer);
for i = 1:max(clone)
    for j = 1:length(layers)
        setpos = intersect(pos,find(clone==i));
        setpos = intersect(setpos,find(strcmp(layer,layers{j})));
        if length(setpos)>=2
            setneg = intersect(neg,find(clone==i));
            setneg = intersect(setneg,find(strcmp(layer,layers{j})));
            if length(setneg)>=0
                count = count + 1;
                simpos(count) = length(setpos) - length(unique(class(setpos)));
                simneg(count) = length(setneg) - length(unique(class(setneg)));
                npos(count) = (length(setpos)*(length(setpos)-1))/2;
                nneg(count) = (length(setneg)*(length(setneg)-1))/2;
            end
        end
    end
end
clear count
sum(simpos)/sum(npos) % 21/154, 13.64%
sum(simneg)/sum(nneg) % 24/157, 15.29%
[chi2stat,p] = ChiSquared([sum(simpos) sum(npos)-sum(simpos); sum(simneg) sum(nneg)-sum(simneg)])
%chi2stat = 0.1711
%p = 0.6792

Y = [sum(simpos)/sum(npos) sum(simneg)/sum(nneg)];
[~,err(1,:)] = binofit(sum(simpos),sum(npos));
[~,err(2,:)] = binofit(sum(simneg),sum(nneg));
scatter(1:2,Y,[],'k','s','filled'); hold on;
errorbar(1:2, Y, Y-err(:,1)',err(:,2)'-Y,'k','LineStyle','none');
ax = gca;
ax.XLim = [0.5 2.5]; ax.YLim = [0 0.4];
ax.YTick = 0:0.1:0.4; ax.XTick = [1 2]; ax.XTickLabel = {'Related','Unrelated'};
ax.Box = 'off';