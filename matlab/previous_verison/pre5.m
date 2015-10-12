%%%---------------------------------------------------------------------------------------------%%%
%%% Filename: pre.m                                                                       %%%
%%% Description: Data Analysis
%%%
% Analyze the Tcptrace data and plot the figures.
%%%---------------------------------------------------------------------------------------------%%%

% function main()
close all
clear all
clc

% Define and initialize the parameters that used in this function
VariMax = 2; % define 2 types of data, time & sequence number
TCP_RX_data = zeros(0,VariMax); % save all lines into a cell

% Read the local file to analysis the data
% fid1 = fopen('p2o_tsg.xpl');
fid1 = fopen('/home/mina/Desktop2/yu/Verizon_NJ---/indoor-slow---unlimited/VRZ_dongle---DL_2x200MB---UL_nothing---MH_5thFloor-UnixRoom-CEO-DemoLab---client/l2k_tsg.xpl');
% Create a file to save the data
fid2 = fopen('OOO_DATA_Output.txt', 'w', 'n', 'utf-8'); 

% Set the expr to select useful informations
expr1 = 'darrow'; % white arrow's first line begin with "darrow"
expr2 = '\ '; % space

disp('Loading the file and matching the useful data...')
% Set the file line by line
SeqN = 0;
last_SeqN = 0;

tline = fgets(fid1);
while ischar(tline)
%     disp(tline)
    if ~isempty(tline) % delete the empty lines
        data_split = regexp(tline, expr2, 'split');
        match_value = strcmp(data_split{1},expr1);
        if (match_value == 1)
            TCP_RX_data(end+1,1) = str2num(data_split{2});
            SeqN = str2num(data_split{3}); 
            if ((SeqN+2^31) < last_SeqN)
                SeqN = SeqN + (2^32 - 1);
            end
            last_SeqN = SeqN;
            TCP_RX_data(end,2) = SeqN;
        end
    end
    tline = fgets(fid1);
end
fclose(fid1);
% TCP_RX_data = cell2mat(TCP_RX_data); % convert the matched data for plot figure

disp('...useful data has been matched')

disp('Finding the unusual data...')
TCP_RX_data_sort = sortrows(TCP_RX_data,2);% sort all data in rows and put them into TCP_RX_data_sort cell
TCP_TX_data = cummax(TCP_RX_data_sort);
CDF_of_diff_TCP_RX_time = diff(TCP_RX_data(:,1));
CDF_of_diff_TCP_TX_time = diff(TCP_TX_data(:,1));
OCC = TCP_TX_data - TCP_RX_data_sort;
% OCC = cummax((TCP_TX_data - cell2mat(TCP_RX_data_sort))/(TCP_TX_data(end,2)-TCP_TX_data(1,2)));

disp('Calculating the number of unusual data and delay')
disp('**********************************************************************************************')
fprintf(fid2,'**********************************************************************************************\n');
% Calculate the matched data for plot the figure
OOO_DATA_calculated = zeros(0, VariMax);
count = 1;
for scount = 1 : 1 : (length(TCP_RX_data_sort)-1)
    if (TCP_RX_data_sort(scount,2) ~= TCP_RX_data_sort((scount+1),2))
        if (TCP_RX_data_sort(scount,1) > TCP_RX_data_sort((scount+1),1))
            fprintf('Found the unusual data from sequence# %d to sequence# %d at %8fs \n',TCP_RX_data_sort(scount,2),TCP_RX_data_sort((scount+1),2),TCP_RX_data_sort(scount,1));
            fprintf(fid2,'Found the unusual data from sequence# %d to sequence# %d at %8fs \n',TCP_RX_data_sort(scount,2),TCP_RX_data_sort((scount+1),2),TCP_RX_data_sort(scount,1));
            delta_seq = TCP_RX_data_sort((scount+1),2) - TCP_RX_data_sort(scount,2);
            delta_time = TCP_RX_data_sort(scount,1) - TCP_RX_data_sort((scount-1),1);
            pkt_block = delta_seq/1388;
            if (pkt_block >= 1)
                OOO_DATA_calculated(count,1) = delta_time;
                OOO_DATA_calculated(count,2) = pkt_block;
                count = count + 1;
            end
            if (delta_seq/1388 > 1)
                fprintf('%d packets have been delayed for %4fs\n',delta_seq/1388,delta_time);
                fprintf(fid2,'%d packets have been delayed for %4fs\n',delta_seq/1388,delta_time);
            else
                fprintf('%d packet has been delayed for %4fs\n',delta_seq/1388,delta_time);
                fprintf(fid2,'%d packet has been delayed for %4fs\n',delta_seq/1388,delta_time);
            end
        end
    end
end
fprintf(fid2,'**********************************************************************************************\n');
disp('**********************************************************************************************')
disp('...all unusual data has been founded')

disp('Ploting the figure...')
% % Plot figure5 for the tcptrace
% figure(5);
% x1 = TCP_RX_data(:,1);
% y1 = TCP_RX_data(:,2);
% plot(x1,y1,'.b');
% hold on;
% axis square;
% grid on;
% xlabel('Time (seconds)');
% ylabel('Seq# (sequence numbers)');

% % figure1 is the CDF_TCP_RX_JITTER
% figure(1);
% CDF_TCP_RX_DIFF_HIST = hist(CDF_of_diff_TCP_RX_time);
% CDF_TCP_RX_JITTER = cumsum(CDF_TCP_RX_DIFF_HIST/length(CDF_of_diff_TCP_RX_time));
% plot(CDF_TCP_RX_JITTER,'-g');
% hold on;
% axis square;
% grid on;
% xlabel('Delta\_T\_of\_TCP\_RX\_DATA (seconds)');
% ylabel('CDF');
% title('CDF of TCP\_RX\_JITTER');
% saveas(1,'CDF of TCP\_RX\_JITTER');
% 
% % figure2 is the histogram
% figure(2);
% CDF_TCP_TX_DIFF_HIST = hist(CDF_of_diff_TCP_TX_time);
% CDF_TCP_TX_JITTER = cumsum(CDF_TCP_TX_DIFF_HIST/length(CDF_of_diff_TCP_TX_time));
% plot(CDF_TCP_TX_JITTER,'-b');
% hold on;
% axis square;
% grid on;
% xlabel('Delta\_T\_of\_TCP\_TX\_DATA (seconds)');
% ylabel('CDF');
% title('CDF of TCP\_TX\_JITTER');
% saveas(2,'CDF of TCP\_TX\_JITTER');
% 
% 
% % figure3 is the histogram
% figure(3);
% h = hist(OCC(:,1));
% CDF = cumsum(h/length(OCC));
% plot(CDF,'-m');
% hold on;
% axis square;
% grid on;
% xlabel('Delay (seconds)');
% ylabel('CDF');
% title('CDF of (TCP\_RX\_time - TCP\_TX\_time)');
% saveas(3,'CDF of (TCP\_RX\_time - TCP\_TX\_time)');
% 
% % figure4 is the Unusual numbers of packets VS dalay
% figure(4);
% x = OOO_DATA_calculated(:,1);
% y = OOO_DATA_calculated(:,2);
% plot(x,y,'or');
% hold on;
% axis square;
% axis([0 10 0 3]);
% grid on;
% xlabel('Out\_of\_order dalay (seconds)');
% ylabel('Out\_of\_order block numbers (1388bytes per block)');
% title('OOO block numbers VS OOO dalay');
% saveas(4,'OOO block numbers VS OOO dalay');

disp('...all the figure have been printed')
disp('Program finished')

% end
