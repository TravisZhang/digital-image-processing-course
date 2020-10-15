% hw1
close all
% problem 1
num_fig = 8;
E_set = [1 2 4 5 6 8 16 32];
m = 0.5;
figure
legend_set = {};
for i = 1:max(size(E_set))
    E = E_set(i);
    r = linspace(0,1,256);
    s = contrast_stretching(r,m,E); 
    subplot(num_fig/2,2,i)
    hold on
    plot(r,s,'-')
    title(['contrast stretching tf, E=',num2str(E),', m=',num2str(m)])
    legend_str = ['E=',num2str(E),', m=',num2str(m)];
    legend_set(i) = {legend_str};
end
% title('contrast stretching tf')
% legend(legend_set)
% problem 2
L = 8;
hist0 = [0.17 0.25 0.21 0.16 0.07 0.08 0.04 0.02];
% hist0 = [0.19 0.25 0.21 0.16 0.08 0.06 0.03 0.02];
hist1 = histogram_equal(hist0,L);
figure
subplot(2,1,1)
bar(linspace(0,L-1,L),hist0)
title('histogram before equal')
subplot(2,1,2)
bar(linspace(0,L-1,L),hist1)
title('histogram after equal')

hist2 = histogram_equal(hist1,L);
figure
subplot(2,1,1)
bar(linspace(0,L-1,L),hist1)
title('histogram before equal')
subplot(2,1,2)
bar(linspace(0,L-1,L),hist2)
title('histogram after equal')
%% functions
function s = contrast_stretching(r,m,E)

s = zeros(max(size(r)));
for i = 1:size(s,1)
    s(i) = 1/(1+(m/r(i))^E);
end

end

function hist1 = histogram_equal(hist0,L)

L0 = max(size(hist0));
hist1 = zeros(L,1);
levels = linspace(0,L-1,L);
% note that hist0 is already a probability set
for i = 1:L0
   s = sum(hist0(1:i));
   level = floor(s*(L-1)+0.5);
   level = level+1; % matlab start from 1
   hist1(level) = hist1(level)+hist0(i);
   fprintf(1,'s: %.3f, level: %d\n',s*(L-1),level-1)
end

end