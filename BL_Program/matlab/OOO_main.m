%%---------------------------------------------------------------------------------------------%%
% Filename: OOO_main.m
% Main program
% Description: Data Analysis for OOO pkts verous delay; 
% Input: the list of each xpl file of each scenario (line 14)
%%---------------------------------------------------------------------------------------------%%

% function main()
close all
clear all
clc

% Read the list file
fileID = fopen('/home/mina/Desktop2/xxx/xxx/xxx/list.txt');
file_list_name = textscan(fileID,'%s');
file_list = file_list_name{1};
fclose(fileID);

delay_bin = 0.001 : 0.005 : 5;

CDF_TCP_RX_JITTER_sum = zeros(size(length(delay_bin)));
CDF_TCP_TX_JITTER_sum = zeros(size(length(delay_bin)));
CDF_sum               = zeros(size(length(delay_bin)));
OOO_DATA_calculated_total = [];

for file_count = 1 : 1 : length(file_list)
    xpl_file_name = file_list{file_count};
    OOO_output = OOO_data(xpl_file_name, delay_bin);
    save([file_list{file_count} '_OOO_data'], '-mat','OOO_output');
    CDF_TCP_RX_JITTER_sum = CDF_TCP_RX_JITTER_sum + OOO_output{1}; 
    CDF_TCP_TX_JITTER_sum = CDF_TCP_TX_JITTER_sum + OOO_output{2}; 
    CDF_sum = CDF_sum + OOO_output{3}; 
    OOO_DATA_calculated_total = [OOO_DATA_calculated_total;OOO_output{4}];
    disp('---------------------------------------------');
    fprintf('No.%d (%s) has been completed.\n',file_count,xpl_file_name);
    disp('---------------------------------------------');
end
save('/home/mina/Desktop2/yu/BL/BL_Program/matlab/OOO_data_calculated.mat','OOO_DATA_calculated_total');
% Calculate all the average data for CDF
CDF_TCP_RX_JITTER_average = CDF_TCP_RX_JITTER_sum/length(file_list);
CDF_TCP_TX_JITTER_average = CDF_TCP_TX_JITTER_sum/length(file_list);
CDF_average = CDF_sum/length(file_list);

% figure5 is the CDF_TCP_RX_JITTER
figure(5);
semilogx(delay_bin, CDF_TCP_RX_JITTER_average,'-g');
hold on;
axis square;
grid on;
xlabel('Delta\_T\_of\_TCP\_RX\_DATA (seconds)');
ylabel('CDF');
title('CDF of TCP\_RX\_JITTER');
saveas(5,'Average_CDF_of_TCP_RX_JITTER');

% figure6 is the histogram
figure(6);
semilogx(delay_bin, CDF_TCP_TX_JITTER_average,'-b');
hold on;
axis square;
grid on;
xlabel('Delta\_T\_of\_TCP\_TX\_DATA (seconds)');
ylabel('CDF');
title('CDF of TCP\_TX\_JITTER');
saveas(6,'Average_CDF_of_TCP_TX_JITTER');


% figure7 is the histogram
figure(7);
semilogx(delay_bin, CDF_average,'-m');
hold on;
axis square;
grid on;
xlabel('Delay (seconds)');
ylabel('CDF');
title('CDF of (TCP\_RX\_time - TCP\_TX\_time)');
saveas(7,'Average_CDF_of_(TCP_RX_time_minus_TCP_TX_time)');

% figure8 is the Unusual numbers of packets VS dalay
figure(8);
x = OOO_DATA_calculated_total(:,1);
y = OOO_DATA_calculated_total(:,2);
plot(x,y,'or');
hold on;
axis square;
% axis([0 5 0 10]);
grid on;
xlabel('Out\_of\_order dalay (seconds)');
ylabel('Out\_of\_order block numbers (1388bytes per block)');
title('OOO block numbers VS OOO dalay');
saveas(8,'Totl_OOO_block_numbers_VS_OOO_dalay');

% % figure9 is the pkt_block VS dalay bins VS HIST by using hist3
% figure(9);
data = OOO_DATA_calculated_total;
delay_bin = 0.001 : 0.005 : 5;
block_size_bin = 1 : 1 : 10;
% bin3 = {delay_bin, block_size_bin};
% hist3(data,bin3);
% % hold on;
% % axis square;
% % grid on;
% xlabel('Delay bins');
% ylabel('Block size');
% zlabel('Hist');
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
% title('3D figure for hist per block_size\&delay bins');
% saveas(9,'3D_figure_for_hist_per_block_size&delay_bins');

% %  figure10 is the pkt_block VS HIST
figure(10);
hist(data(:,1),delay_bin);
axis([-0.5 5 0 inf]);
xlabel('Delay bins');
ylabel('Hist');
saveas(10,'Hist_VS_Delay_bins');

% %  figure11 is the dalay_bins VS HIST
figure(11);
hist(data(:,2),block_size_bin);
axis([0 10 0 inf]);
xlabel('Block size');
ylabel('Hist');
saveas(11,'Hist_VS_Block_size');

disp(' ')
disp('#########################################################')
disp(' ')
disp('OOO_Data_Analysis_Program has been successfully completed')
disp(' ')
disp('#########################################################')

% end