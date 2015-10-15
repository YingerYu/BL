load /Users/yu/Documents/MATLAB/dat_calculated.mat

data = OOO_DATA_calculated_total;
delay_bin = 0.001 : 0.05 : 5;
block_size_bin = 1 : 1 : 10;
% bin3 = {block_size_bin, delay_bin};
bin3 = {delay_bin, block_size_bin};

hist3(data,bin3);
shading flat
xlabel('Delay bins');
ylabel('Block Size');
zlabel('HIST');
% title('');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
