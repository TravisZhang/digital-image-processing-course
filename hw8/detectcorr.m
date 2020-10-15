function [ Ccorr,Cconv ] = detectcorr(template_name, reference_name)
figure(101); 

% Read template and reference images as DOUBLE arrays T and R 
%   respectively, then convert to GRAYSCALE
%   e.g. template_name = 'waldo.jpg', reference_name = 'whereswaldo.jpg'
% WRITE CODE HERE
R = double(rgb2gray(imread(reference_name)));
T = double(rgb2gray(imread(template_name)));
% N1 = conv2(T,R);
Tsize = size(T);
Rsize = size(R);
R = R-mean(mean(R)).*ones(Rsize);
T = T-mean(mean(T)).*ones(Tsize);

% Compute the normalized correlation
% WRITE CODE HERE
N = xcorr2(R,T);
Nsize = size(N);
N1 = conv2(R,rot90(T,2));
a = zeros(1,Nsize(2));
temp1 = 0;

for i = 1:Tsize(1)
	for j = 1:Tsize(2)
        temp1 = temp1 + abs(T(i,j)).^2;
	end
end
D1 = sqrt(temp1);

P = ones(Rsize);
A = xcorr2(P,R.^2);
temp2 = A(Rsize(1),Rsize(2));
D2 = sqrt(temp2);

b = 0;
while b < 2
    if b == 1
        N = N1;
    end

    for p = 1:Nsize(1)
        for q = 1:Nsize(2)
            N(p,q)=N(p,q)/(D1*D2);
        end
    end
    b = b+1;
    a = cat(1,a,N); 
end

asize = size(a);
a = mat2cell(a,[1 0.5*(asize(1)-1) 0.5*(asize(1)-1)]);
Ccorr = a{2};
Cconv = a{3};

% Find the row and col index of max. corr.
% WRITE CODE HERE
[r,c]=ind2sub(size(Ccorr),find(Ccorr==max(max(Ccorr))));

% Draw a rectangle of size Tsize around the image region best
% matching the template. 
R = rgb2gray(imread(reference_name));
subplot(121); imshow(R); hold on
rectangle(  'Position',[c-Tsize(2) r-Tsize(1) Tsize(2) Tsize(1)], ...
            'EdgeColor','r','LineWidth',2);
title('Detection by Correlation')
      
% Do the same thing again with the 2D convolution:
% WRITE CODE HERE
[r,c]=ind2sub(size(Cconv),find(Cconv==max(max(Cconv))));
subplot(122); imshow(R); hold on
rectangle(  'Position',[c-Tsize(2) r-Tsize(1) Tsize(2) Tsize(1)], ...
            'EdgeColor','r','LineWidth',2);
title('Detection by Convolution')
end