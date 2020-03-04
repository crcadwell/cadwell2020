
clear all; close all
cd /Users/cathryn/Dropbox/Microcolumn' Paper'/Neuron' version 2018'/Revision1/New' Clone Quantification Data'/21488pup1
slices  = [1:42];

for i = 1:length(slices)
    clear filename image imageRed
    cd Raw' images'
    filename = ['Slice' num2str(slices(i)) '_TileScan_001_Merging_Processed001_ch00.tif'];
    imageRed = imread(filename);
    figure('Position',[0 500 500 500]); imshow(imageRed); hold on; title (['Slice ' num2str(slices(i))]);
    cd ../Segmented
    load(['Slice' num2str(slices(i)) 'var.mat'])
    plot(cellxy(1,:), cellxy(2,:), 'g.','MarkerSize',20)
    plot(lsurfacexys(1,:),lsurfacexys(2,:),'b-');
    plot(rsurfacexys(1,:),rsurfacexys(2,:),'b-');
    plot(lbottomxys(1,:),lbottomxys(2,:),'b-');
    plot(rbottomxys(1,:),rbottomxys(2,:),'b-');    
    hold off;
    s(slices(i)).BWleft = BWleft;
    s(slices(i)).BWright = BWright;
    s(slices(i)).cellxy = cellxy;
    s(slices(i)).lbottomxys = lbottomxys;
    s(slices(i)).lsurfacexys = lsurfacexys;
    s(slices(i)).rbottomxys = rbottomxys;
    s(slices(i)).rsurfacexys = rsurfacexys;
    set(gcf,'KeyPressFcn',@CountCells);
    cd ..
    clear BWleft BWright cellxy lbottomxys lsurfacexys rbottomxys rsurfacexys imageRed filename i
    pause(1)
end
cd ..

