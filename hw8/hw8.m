% hw8
close all 
clear

% P3
%% 1. read fig & select roi
f = imread('hermione.jpg');
mask = roipoly(f);
red = immultiply(mask,f(:,:,1));
green = immultiply(mask,f(:,:,2));
blue = immultiply(mask,f(:,:,3));
g = cat(3,red,green,blue);
figure
imshow(g)

%% 2. calculate similarity
[M,N,k] = size(g);
I = reshape(g,M*N,3);
idx = find(mask);
I = double(I(idx,1:3));
[C,m] = covmatrix(I);
d = diag(C);
sd = sqrt(d)';
e25_m = colorseg('mahalanobis',f,25,m,C);
e25_e = colorseg('euclidean',f,25,m);

figure
num_pic = 3;
subplot(1,num_pic,1)
imshow(f)
title('original')
subplot(1,num_pic,2)
imshow(e25_m)
title('mahalanobis')
subplot(1,num_pic,3)
imshow(e25_e)
title('euclidean')
