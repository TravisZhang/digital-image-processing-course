% hw4
close all
clear
addpath('dipum_images_ch03')

f = imread('Fig0310(a)(Moon Phobos).tif');
f = imread('Fig0316(a)(moon).tif');
f1 = imread('Fig0315(a)(original_test_pattern).tif');
f1 = im2double(f1);
f = im2double(f);

% crop f to be same size as f1
min_rows = min(size(f,1),size(f1,1));
min_cols = min(size(f,2),size(f1,2));
f = f(1:min_rows,1:min_cols);
f1 = f1(1:min_rows,1:min_cols);

F = fft2(f);
S = abs(F); % magnitude
Fc = fftshift(F);
Sc = abs(Fc);
A = angle(F);
Ac = angle(Fc);
% A_test = atan(real(F)/imag(F));

F1 = fft2(f1);
S1 = abs(F1);
A1 = angle(F1);


%  exchange f & f1's phase
Fr = S.*cos(A1)+S.*sin(A1).*1i;
Fr1 = S1.*cos(A)+S1.*sin(A).*1i;
fr = real(ifft2(Fr));
fr1 = real(ifft2(Fr1));

figure
num_figures = 5;
subplot(1,num_figures,1)
imshow(f)
title('original photo')
subplot(1,num_figures,2)
imshow(S,[])
title('original magnitude')
subplot(1,num_figures,3)
imshow(Sc,[])
title('shifted magnitude')
subplot(1,num_figures,4)
imshow(A,[])
title('original phase')
subplot(1,num_figures,5)
imshow(Ac,[])
title('shifted phase')
% [] is auto contrast expansion

figure
rows = 2;
cols = 2;
subplot(rows,cols,1)
imshow(f)
title('photo 1')
subplot(rows,cols,3)
imshow(f1)
title('photo 2')

subplot(rows,cols,2)
imshow(fr,[])
title('1 magnitude with 2 phase')
subplot(rows,cols,4)
imshow(fr1,[])
title('2 magnitude with 1 phase')

