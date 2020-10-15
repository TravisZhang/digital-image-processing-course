% hw2
close all
clear
% convolution
% p1
x = [1 2 3 4 3 2 1];
y = [2 0 -2];
% x = [1 3 2 0 4;1 0 3 2 3;0 4 1 0 5;2 3 2 1 4;3 1 0 4 2];
% y = [-1 0 1;-2 0 2;-1 0 1];
xy = imfilter(x, y, 'conv','full');
z = [1 2 3];
xyz = imfilter(xy, z, 'conv','full');
yz = imfilter(y, z, 'conv','full');
xyz1 = imfilter(x, yz, 'conv','full');
xz = imfilter(x, z, 'conv','full'); 
x_yaddz = xy + xz;
yaddz = y+z;
x_yaddz1 = imfilter(x, yaddz, 'conv','full');
% p2
f = [-1 0 1;-2 0 2;-1 0 1];
g = [1 3 2 0 4;1 0 3 2 3;0 4 1 0 5;2 3 2 1 4;3 1 0 4 2];
fg = imfilter(f, g, 'conv','full');
% sobel
f = imread('Fig0310(a)(Moon Phobos).tif');
f = imread('Fig0316(a)(moon).tif');
f = im2double(f);
w_sobel_lat = [-1 -2 -1;0 0 0;1 2 1];
w_sobel_lon = [-1 0 1;-2 0 2;-1 0 1];
fw_lat = imfilter(f, w_sobel_lat, 'corr', 'replicate');
fw_lon = imfilter(f, w_sobel_lon, 'corr', 'replicate');
% enhance
f_en = f+fw_lat+fw_lon;
% plot
figure
subplot(1,4,1)
imshow(f)
title('original')
subplot(1,4,2)
imshow(fw_lat)
title('lateral filter')
subplot(1,4,3)
imshow(fw_lon)
title('longitudinal filter')
subplot(1,4,4)
imshow(f_en)
title('enhanced')