function CountCells(src,event)

slices = evalin('base','slices');
s = evalin('base','s');
fig = gcf;
slice = slices(fig.Number);
[x,y] = ginput(4);
mask = poly2mask(x,y,size(s(slice).BWleft,1),size(s(slice).BWleft,2));
figure; imshow(mask);hold on

count = 0;
cell = [];

for i = 1:size(s(slice).cellxy,2)
    if mask(ceil(s(slice).cellxy(2,i)),ceil(s(slice).cellxy(1,i)))==1
        count = count + 1;
        cell(count,:) = s(slice).cellxy(:,i);
    end
end
plot(cell(:,1),cell(:,2),'ro');
count

figure(fig); hold on; plot(cell(:,1),cell(:,2),'g+')
end
