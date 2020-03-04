clear all; close all;
%addpath /Volumes/'Seagate Backup Plus Drive'/Data/Analysis
addpath /Users/cathryn/Dropbox/Microcolumn' paper'/Neuron' version 2018'/Revision1/New' Clone Quantification Data'

cd /Users/cathryn/Dropbox/Microcolumn' paper'/Neuron' version 2018'/Revision1/New' Clone Quantification Data'/21488pup1/Raw' images'
dim1 = 512;
dim2 = 256;

%%
slice = 47;
filename = ['Slice' num2str(slice) '_TileScan_001_Merging_Processed001_ch00.tif'];
%filename = ['slice' num2str(slice) '.lsm'];
image = imread(filename);

%
% Separate channels

imageRed = image;
imageRed = imageRed.*1.8;
%imageBlue = image(:,:,2);

clear ymin ymax xmin xmax

% Find surfaces
% Surface of left cortex
imshow(imageRed)
title('Outline the surface of the left/top cortex')
lsurfacexy = [];
n = 0;
but = 1;
while but == 1
    if n == 0
        [xi,yi,but] = ginput(1);
        ymin = yi-dim1;
        if ymin<1
            ymin = 1;
        end
        ymax = yi+dim1;
        if ymax>size(imageRed,1)
            ymax = size(imageRed,1);
        end
        xmin = xi-dim1;
        if xmin<1
            xmin = 1;
        end 
        xmax = xi+dim1;
        if xmax>size(imageRed,2)
            xmax = size(imageRed,2);
        end
        n = n+1;
        lsurfacexy(:,n) = [xi;yi];
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the surface of the left/top cortex');
        hold on
        xi = xi-xmin;
        yi = yi-ymin;
        plot(xi,yi,'ro');
        hold off
    else
        [xi,yi,but] = ginput(1);
        n = n+1;
        lsurfacexy(:,n) = [xmin+xi,ymin+yi];
        ymin = yi+ymin-dim1;
        if ymin<1
            ymin = 1;
        end
        ymax = yi+ymin+dim1;
        if ymax>size(imageRed,1)
            ymax = size(imageRed,1);
        end
        xmin = xi+xmin-dim1;
        if xmin<1
            xmin = 1;
        end 
        xmax = xi+xmin+dim1;
        if xmax>size(imageRed,2)
            xmax = size(imageRed,2);
        end
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the surface of the left/top cortex');
        hold on
        t = 1:n;
        ts = 1:0.01:n;
        lsurfacexys = spline(t,lsurfacexy,ts);
        for i = 1:size(lsurfacexys,2)
            if xmin<lsurfacexys(1,i) && lsurfacexys(1,i)<xmax && ymin<lsurfacexys(2,i) && lsurfacexys(2,i)<ymax
                plot((lsurfacexys(1,i)-xmin),(lsurfacexys(2,i)-ymin),'bo');
            end
        end
        hold off
    end
end

%Bottom of left cortex
imshow(imageRed)
title('Outline the bottom of the left/top cortex')
lbottomxy = [];
n = 0;
but = 1;
while but == 1
    if n == 0
        [xi,yi,but] = ginput(1);
        ymin = yi-dim1;
        if ymin<1
            ymax = ymax-ymin;
            ymin = 1;
        end
        ymax = yi+dim1;
        if ymax>size(imageRed,1)
            ymin = ymin-(ymax-size(imageRed,1));
            ymax = size(imageRed,1);
        end
        xmin = xi-dim1;
        if xmin<1
            xmax = xmax-xmin;
            xmin = 1;
        end 
        xmax = xi+dim1;
        if xmax>size(imageRed,2)
            xmin = xmin-(xmax-size(imageRed,2));
            xmax = size(imageRed,2);
        end
        n = n+1;
        lbottomxy(:,n) = [xi;yi];
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the bottom of the left/top cortex');
        hold on
        xi = xi-xmin;
        yi = yi-ymin;
        plot(xi,yi,'ro');
        hold off
    else
        [xi,yi,but] = ginput(1);
        n = n+1;
        lbottomxy(:,n) = [xmin+xi,ymin+yi];
        ymin = yi+ymin-dim1;
        if ymin<1
            ymin = 1;
        end
        ymax = yi+ymin+dim1;
        if ymax>size(imageRed,1)
            ymax = size(imageRed,1);
        end
        xmin = xi+xmin-dim1;
        if xmin<1
            xmin = 1;
        end 
        xmax = xi+xmin+dim1;
        if xmax>size(imageRed,2)
            xmax = size(imageRed,2);
        end
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the surface of the left/top cortex');
        hold on
        t = 1:n;
        ts = 1:0.01:n;
        lbottomxys = spline(t,lbottomxy,ts);
        for i = 1:size(lbottomxys,2)
            if xmin<lbottomxys(1,i) && lbottomxys(1,i)<xmax && ymin<lbottomxys(2,i) && lbottomxys(2,i)<ymax
                plot((lbottomxys(1,i)-xmin),(lbottomxys(2,i)-ymin),'bo');
            end
        end
        hold off
    end
end
% Surface of right cortex
imshow(imageRed)
title('Outline the surface of the right/bottom cortex')
rsurfacexy = [];
n = 0;
but = 1;
while but == 1
    if n == 0
        [xi,yi,but] = ginput(1);
        ymin = yi-dim1;
        if ymin<1
            ymax = ymax-ymin;
            ymin = 1;
        end
        ymax = yi+dim1;
        if ymax>size(imageRed,1)
            ymin = ymin-(ymax-size(imageRed,1));
            ymax = size(imageRed,1);
        end
        xmin = xi-dim1;
        if xmin<1
            xmax = xmax-xmin;
            xmin = 1;
        end 
        xmax = xi+dim1;
        if xmax>size(imageRed,2)
            xmin = xmin-(xmax-size(imageRed,2));
            xmax = size(imageRed,2);
        end
        n = n+1;
        rsurfacexy(:,n) = [xi;yi];
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the surface of the right/bottom cortex');
        hold on
        xi = xi-xmin;
        yi = yi-ymin;
        plot(xi,yi,'ro');
        hold off
    else
        [xi,yi,but] = ginput(1);
        n = n+1;
        rsurfacexy(:,n) = [xmin+xi,ymin+yi];
        ymin = yi+ymin-dim1;
        if ymin<1
            ymin = 1;
        end
        ymax = yi+ymin+dim1;
        if ymax>size(imageRed,1)
            ymax = size(imageRed,1);
        end
        xmin = xi+xmin-dim1;
        if xmin<1
            xmin = 1;
        end 
        xmax = xi+xmin+dim1;
        if xmax>size(imageRed,2)
            xmax = size(imageRed,2);
        end
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the surface of the right/bottom cortex');
        hold on
        t = 1:n;
        ts = 1:0.01:n;
        rsurfacexys = spline(t,rsurfacexy,ts);
        for i = 1:size(rsurfacexys,2)
            if xmin<rsurfacexys(1,i) && rsurfacexys(1,i)<xmax && ymin<rsurfacexys(2,i) && rsurfacexys(2,i)<ymax
                plot((rsurfacexys(1,i)-xmin),(rsurfacexys(2,i)-ymin),'bo');
            end
        end
        hold off
    end
end

%Bottom of right cortex
imshow(imageRed)
title('Outline the bottom of the right/bottom cortex')
rbottomxy = [];
n = 0;
but = 1;
while but == 1
    if n == 0
        [xi,yi,but] = ginput(1);
        ymin = yi-dim1;
        if ymin<1
            ymax = ymax-ymin;
            ymin = 1;
        end
        ymax = yi+dim1;
        if ymax>size(imageRed,1)
            ymin = ymin-(ymax-size(imageRed,1));
            ymax = size(imageRed,1);
        end
        xmin = xi-dim1;
        if xmin<1
            xmax = xmax-xmin;
            xmin = 1;
        end 
        xmax = xi+dim1;
        if xmax>size(imageRed,2)
            xmin = xmin-(xmax-size(imageRed,2));
            xmax = size(imageRed,2);
        end
        n = n+1;
        rbottomxy(:,n) = [xi;yi];
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the bottom of the right/bottom cortex');
        hold on
        xi = xi-xmin;
        yi = yi-ymin;
        plot(xi,yi,'ro');
        hold off
    else
        [xi,yi,but] = ginput(1);
        n = n+1;
        rbottomxy(:,n) = [xmin+xi,ymin+yi];
        ymin = yi+ymin-dim1;
        if ymin<1
            ymin = 1;
        end
        ymax = yi+ymin+dim1;
        if ymax>size(imageRed,1)
            ymax = size(imageRed,1);
        end
        xmin = xi+xmin-dim1;
        if xmin<1
            xmin = 1;
        end 
        xmax = xi+xmin+dim1;
        if xmax>size(imageRed,2)
            xmax = size(imageRed,2);
        end
        imshow(imageRed(round(ymin):round(ymax),round(xmin):round(xmax)))
        axis image
        title('Outline the surface of the right/bottom cortex');
        hold on
        t = 1:n;
        ts = 1:0.01:n;
        rbottomxys = spline(t,rbottomxy,ts);
        for i = 1:size(rbottomxys,2)
            if xmin<rbottomxys(1,i) && rbottomxys(1,i)<xmax && ymin<rbottomxys(2,i) && rbottomxys(2,i)<ymax
                plot((rbottomxys(1,i)-xmin),(rbottomxys(2,i)-ymin),'bo');
            end
        end
        hold off
    end
end

% create masks over cortex

xleft = [lsurfacexys(1,:) lbottomxys(1,:)];
yleft = [lsurfacexys(2,:) lbottomxys(2,:)];
BWleft = poly2mask(xleft, yleft,size(imageRed,1), size(imageRed,2));

xright = [rsurfacexys(1,:) rbottomxys(1,:)];
yright = [rsurfacexys(2,:) rbottomxys(2,:)];
BWright = poly2mask(xright, yright,size(imageRed,1), size(imageRed,2));

% Find neurons, one section at a time

ncol = size(imageRed,2)/dim2;
nrow = size(imageRed,1)/dim2;
cells = [];
n = 0;
but=1;
for j = 0:(nrow-1)
    for i = 0:(ncol-1)
        y = 1+dim2*j:dim2+dim2*j;
        x = 1+dim2*i:dim2+dim2*i;
        if ~isempty(find(BWleft(y,x)==1,1)) || ~isempty(find(BWright(y,x)==1,1))
            imshow(imageRed(y,x))
            axis image
            set(gcf,'Color',[0 0 0]);
            title('Select Cells','Color','w')
            hold on
            while but == 1
                [xi,yi,but] = ginput(1);
                if xi<0 || xi>dim2 || yi<0 || yi>dim2
                    break
                end
                plot(xi,yi,'ro');
                n = n+1;
                cells(:,n) = [xi+dim2*i,yi+dim2*j];
            end
            hold off
            but=1;
        end
    end
end

% remove cells outside of mask

cellxyoriginal = cells;
cellxy = [];
count = 0;
for i = 1:size(cells,2)
    if i<=size(cells,2)
        xi = ceil(cells(1,i));
        yi = ceil(cells(2,i));
        if (BWleft(ceil(yi),ceil(xi)) == 1) || (BWright(ceil(yi),ceil(xi)) == 1)
            count = count +1 ;
            cellxy(:,count) = cells(:,i);
        end
    end
end

% Show final points and save them to file

imshow(imageRed)
hold on
plot(cellxyoriginal(1,:), cellxyoriginal(2,:), 'ro')
plot(cellxy(1,:), cellxy(2,:), 'go')
plot (lsurfacexys(1,:),lsurfacexys(2,:),'b-');
plot (rsurfacexys(1,:),rsurfacexys(2,:),'b-');
plot (lbottomxys(1,:),lbottomxys(2,:),'b-');
plot (rbottomxys(1,:),rbottomxys(2,:),'b-');
%
cd ../Segmented
save(['Slice' num2str(slice) 'var'],'cellxy','lsurfacexys','rsurfacexys','lbottomxys','rbottomxys','BWleft','BWright');
cd ../Raw' images'


