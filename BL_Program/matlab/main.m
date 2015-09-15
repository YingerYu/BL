% function main()
close all
clear all
clc

% Read the list file
fileID = fopen('/home/mina/Desktop2/yu/full.txt');
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
    pre_output = pre7(xpl_file_name, delay_bin);
    save([file_list{file_count} '_MATLAB'], '-mat','pre_output');
    CDF_TCP_RX_JITTER_sum = CDF_TCP_RX_JITTER_sum + pre_output{1}; 
    CDF_TCP_TX_JITTER_sum = CDF_TCP_TX_JITTER_sum + pre_output{2}; 
    CDF_sum = CDF_sum + pre_output{3}; 
    OOO_DATA_calculated_total = [OOO_DATA_calculated_total;pre_output{4}];
end

% Calculate all the average data for CDF
CDF_TCP_RX_JITTER_average = CDF_TCP_RX_JITTER_sum/length(file_list);
CDF_TCP_TX_JITTER_average = CDF_TCP_TX_JITTER_sum/length(file_list);
CDF_average = CDF_sum/length(file_list);

% % figure5 is the CDF_TCP_RX_JITTER
% figure(5);
% semilogx(delay_bin, CDF_TCP_RX_JITTER_average,'-g');
% hold on;
% axis square;
% grid on;
% xlabel('Delta\_T\_of\_TCP\_RX\_DATA (seconds)');
% ylabel('CDF');
% title('CDF of TCP\_RX\_JITTER');
% saveas(5,'Average_CDF of TCP\_RX\_JITTER');
% 
% % figure6 is the histogram
% figure(6);
% semilogx(delay_bin, CDF_TCP_TX_JITTER_average,'-b');
% hold on;
% axis square;
% grid on;
% xlabel('Delta\_T\_of\_TCP\_TX\_DATA (seconds)');
% ylabel('CDF');
% title('CDF of TCP\_TX\_JITTER');
% saveas(6,'Average_CDF of TCP\_TX\_JITTER');
% 
% 
% % figure7 is the histogram
% figure(7);
% semilogx(delay_bin, CDF_average,'-m');
% hold on;
% axis square;
% grid on;
% xlabel('Delay (seconds)');
% ylabel('CDF');
% title('CDF of (TCP\_RX\_time - TCP\_TX\_time)');
% saveas(7,'Average_CDF of (TCP\_RX\_time - TCP\_TX\_time)');
% 
% % figure8 is the Unusual numbers of packets VS dalay
% figure(8);
% x = OOO_DATA_calculated_total(:,1);
% y = OOO_DATA_calculated_total(:,2);
% plot(x,y,'or');
% hold on;
% axis square;
% axis([0 5 0 2]);
% grid on;
% xlabel('Out\_of\_order dalay (seconds)');
% ylabel('Out\_of\_order block numbers (1388bytes per block)');
% title('OOO block numbers VS OOO dalay');
% saveas(8,'Totl_OOO block numbers VS OOO dalay');

% figure9 is the pkt_block VS dalay bins VS HIST
figure(9);
x = OOO_DATA_calculated_total(:,1);
y = OOO_DATA_calculated_total(:,2);
plot(x,y,'or');
hold on;
axis square;
% axis([0 5 0 2]);
grid on;
xlabel('Out\_of\_order dalay (seconds)');
ylabel('Out\_of\_order block numbers (1388bytes per block)');
title('OOO block numbers VS OOO dalay');
saveas(9,'Totl_OOO block numbers VS OOO dalay');

% end