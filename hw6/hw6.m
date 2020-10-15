% hw6
close all
clear
addpath('dipum_images_ch03')
% P3
% get checker board
f = checkerboard(64);
F = fft2(f);
Fc = fftshift(F);
f1 = ifft2(F);
% apply motion blur and other noise
len = 40;
theta = 45;
PSF = fspecial('motion',len,theta);
gb = imfilter(f,PSF,'circular');
noise_gau = imnoise(zeros(size(f)),'gaussian',0,0.001); % gaussian noise
C = [0 64;0 128;32 32;64 0;128 0;-32 32];
[noise_sin,R_sin,S_sin] = imnoise3_corrected(size(f,1),size(f,2),C);
% g = gb + noise_sin;
g = gb;
G = fft2(g);
Gc = fftshift(G);
g1 = ifft2(G);
% get degradation function H
H_real = get_H_real(F,G);
H_real_0 = freqz2(PSF,size(F,2),size(F,1)); % already move origin to center from upper left
figure
subplot(1,3,1)
mesh(abs(fftshift(H_real)))
title('H_real')
subplot(1,3,2)
mesh(abs(H_real_0))
title('H_real_0')
T = 1;
H = get_degradation_function(size(f,1),size(f,2),len,theta,T);
subplot(1,3,3)
mesh(abs(H))
title('H')
% get f_hat with limited radius H
R_min = 250;
fig_num = 4;
R_set = linspace(R_min, size(f,1)/2,fig_num);
f_hat_set = cell(size(R_set));
for i = 1:max(size(R_set))
%     H_cut = cut_off_radius(H,R_set(i));
    H_cut = H;
    F_hat = dot_divide(Gc,H_cut);
    F_hat = ifftshift(F_hat);
    f_hat = real(ifft2(F_hat));
    g_hat = dftfilt(f, ifftshift(H));
%     f_hat_set(i) = mat2cell(f_hat,1);
end


%% plot
% figure
% imshow(f)

figure
subplot(1,2,1)
% imshow(S_sin,[])
spy(S_sin)
title('sinosoid noise spectrum')
subplot(1,2,2)
imshow(noise_sin,[])
title('sinosoid noise')

figure
subplot(1,2,1)
imshow(gb)
title('motion blurred')
subplot(1,2,2)
imshow(g)
title('motion blurred with sinosoid noise')

% figure
% for i = 1:num_fig
%     subplot(1,num_fig,i)
%     imshow(f_hat_set(i))
%     title(['restore with radius ',num2str(R_set(i))])
% end

%% function
function H = get_degradation_function(M,N,len,theta,T)

a = -len*cos(theta/180*pi);
b = len*sin(theta/180*pi);
H = zeros(M,N);
for i = 1:M
    for j = 1:N
        u = i-M/2;
        v = j-N/2;
        temp = pi*(u*a+v*b);
        H(i,j) = T/temp*sin(temp)*exp(-1i*temp);
    end
end

end

function H_cut = cut_off_radius(H,R)

[M,N] = size(H);
H_cut = zeros(size(H));
for i = 1:size(H,1)
    for j = 1:size(H,2)
        u = i-M/2;
        v = j-N/2;
        R_temp = u^2+v^2;
        if R_temp <= R^2
            H_cut(i,j) = H(i,j);
        end
    end
end

end

function F = dot_divide(G,H)

F = zeros(size(G));
for i = size(G,1)
    for j = size(G,2)
        if H(i,j) > 1e-6
            F(i,j) = G(i,j)/H(i,j);
        end
    end
end

end

function H_real = get_H_real(F,G)

H_real = zeros(size(G));
for i = 1:size(G,1)
    for j = 1:size(G,2)
        if F(i,j) < 1e-6
            H_real(i,j) = 0;
        else
            H_real(i,j) = G(i,j) / F(i,j);
        end
    end
end

end