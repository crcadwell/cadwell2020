%% Panel 4G
close all; figure;
yu = 0.018677689;
errYu = 0.005251506;

subplot(2,1,1)
X = 1:2;
Y = [0.05047763 0.032933336];
errY = [0.018498997 0.028690825];
scatter(X,Y,100,'r','s','filled'); hold on; 
errorbar(X,Y,errY,'k','Linestyle','none');
ax = gca; ax.XLim = [0.5 2.5]; ax.YLim = [0 0.3]; ax.XTick = 1:2; ax.XTickLabels = {'From L4','From L5'};
ax.YTick = 0:0.1:0.3; ylabel('Fraction of input to L2/3');
plot(ax.XLim,[yu yu],'--k'); plot(ax.XLim, [yu-errYu yu-errYu],'--','Color',[0.5 0.5 0.5]); plot(ax.XLim,[yu+errYu yu+errYu],'--','Color',[0.5 0.5 0.5]);

subplot(2,1,2)
X = 1:2;
Y = [0.136172458 0.140245583];
errY = [0.094498217 0.094596479];
scatter(X,Y,100,'r','s','filled'); hold on; 
errorbar(X,Y,errY,'k','Linestyle','none');
ax = gca; ax.XLim = [0.5 2.5]; ax.YLim = [0 0.3]; ax.XTick = 1:2; ax.XTickLabels = {'From L2/3','From L4'};
ax.YTick = 0:0.1:0.3; ylabel('Fraction of input to L5');
plot(ax.XLim,[yu yu],'--k'); plot(ax.XLim, [yu-errYu yu-errYu],'--','Color',[0.5 0.5 0.5]); plot(ax.XLim,[yu+errYu yu+errYu],'--','Color',[0.5 0.5 0.5]);

%% Panel 5E
close all; figure;
yu = 0.018677689;
errYu = 0.005251506;

X = 1:3;
Y = [0.010464466 0.030154849 0.007281445];
errY = [0.007592049 0.010664634 0.007374484];
scatter(X,Y,100,'r','s','filled'); hold on; 
errorbar(X,Y,errY,'k','Linestyle','none');
ax = gca; ax.XLim = [0.5 3.5]; ax.YLim = [0 0.05]; ax.XTick = 1:3; ax.XTickLabels = {'Within L2/3','Within L4','Within L5'};
ax.YTick = 0:0.01:0.05; ylabel('Fraction of lateral input');
plot(ax.XLim,[yu yu],'--k'); plot(ax.XLim, [yu-errYu yu-errYu],'--','Color',[0.5 0.5 0.5]); plot(ax.XLim,[yu+errYu yu+errYu],'--','Color',[0.5 0.5 0.5]);
