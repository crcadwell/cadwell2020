clear all; close all;

X = 0:0.1:30;
Y = xlsread('Power.xls');
foldChange = xlsread('FoldChange.xls');
Prl = xlsread('Prl.xls');

figure

subplot(2,1,1)
unrel = (51/626);
for i = 1:10
    plot(X,Prl(i,:),'Color','k');
    try 
        points (i,:) = InterX([X;Prl(i,:)],[foldChange(i) foldChange(i); 0 0.2]);
    catch
        points (i,:) = [foldChange(i),1];
    end
    hold on
end
s = scatter(points(:,1),points(:,2),'r*');
ylim([0 0.2])
ax = gca; ax.Box = 'off';
actual = (14/248);
a = plot(ax.XLim,[actual actual],'b--');
xlabel('Fold Change in Connectivity (RGC-related/unrelated)');
ylabel('Prl');
legend([a; s],{'Observed Prl','Predicted Prl'},'Location','southeast');
legend('boxoff')
ax.XTick = [1 5 10 15 20 25 30];
ax.XGrid = 'on';
ax.YGrid = 'on';


subplot(2,1,2)
for i = 1:10
    plot(X,Y(i,:),'Color','k');
    hold on
    points(i,:) = InterX([X;Y(i,:)],[foldChange(i) foldChange(i); 0 1]);
end
s = scatter(points(:,1), points(:,2),'r*');
ylim([0 1])
ax = gca; ax.Box = 'off';
actual = (14/248)/(51/626);
a = plot([actual actual],[0 1],'b--');
xlabel('Fold Change in Connectivity (RGC-related/unrelated)');
ylabel('Statistical Power');
legend([a; s],{'Observed Fold Change','Predicted Fold Change'},'Location','southeast');
legend('boxoff')
ax.XTick = [1 5 10 15 20 25 30];
ax.XGrid = 'on';
ax.YGrid = 'on';

