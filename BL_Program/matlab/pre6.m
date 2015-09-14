%%%---------------------------------------------------------------------------------------------%%%
%%% Filename: pre.m                                                                       %%%
%%% Description: Data Analysis
%%%
% Analyze the Tcptrace data and plot the figures.
%%%---------------------------------------------------------------------------------------------%%%


function pre_output = pre6(xpl_file_name)
% close all
% clear all
% clc

% Define and initialize the parameters that used in this function
VariMax = 2; % define 2 types of data, time & sequence number
TCP_RX_data = zeros(0,VariMax); % save all lines into a matrix

% Read the local file to analysis the data
fid1 = fopen(xpl_file_name);

% Create a file to save the data
output_name = [xpl_file_name,'_OOO_DATA_Output.txt'];
save(output_name);
fid2 = fopen(output_name, 'w', 'n', 'utf-8'); 

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
    if (TCP_RX_data_sort(scount,1) > TCP_RX_data_sort((scount+1),1))
        fprintf('Found the unusual data from sequence# %d to sequence# %d at %8fs \n',TCP_RX_data_sort(scount,2),TCP_RX_data_sort((scount+1),2),TCP_RX_data_sort(scount,1));
        fprintf(fid2,'Found the unusual data from sequence# %d to sequence# %d at %8fs \n',TCP_RX_data_sort(scount,2),TCP_RX_data_sort((scount+1),2),TCP_RX_data_sort(scount,1));
        delta_seq = TCP_RX_data_sort((scount+1),2) - TCP_RX_data_sort(scount,2);
        delta_time = TCP_RX_data_sort(scount,1) - TCP_RX_data_sort((scount-1),1);
        OOO_DATA_calculated(count,1) = delta_time;
        OOO_DATA_calculated(count,2) = delta_seq/1388;
        count = count + 1;
        if (delta_seq/1388 > 1)
            fprintf('%d packets have been delayed for %4fs\n',delta_seq/1388,delta_time);
            fprintf(fid2,'%d packets have been delayed for %4fs\n',delta_seq/1388,delta_time);
        else
            fprintf('%d packet has been delayed for %4fs\n',delta_seq/1388,delta_time);
            fprintf(fid2,'%d packet has been delayed for %4fs\n',delta_seq/1388,delta_time);
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

% figure1 is the CDF_TCP_RX_JITTER
figure(1);
% a1 = [xpl_file_name,'1'];
% figure(a1);
CDF_TCP_RX_DIFF_HIST = hist(CDF_of_diff_TCP_RX_time);
CDF_TCP_RX_JITTER = cumsum(CDF_TCP_RX_DIFF_HIST/length(CDF_of_diff_TCP_RX_time));
plot(CDF_TCP_RX_JITTER,'-g');
hold on;
axis square;
grid on;
xlabel('Delta\_T\_of\_TCP\_RX\_DATA (seconds)');
ylabel('CDF');
title('CDF of TCP\_RX\_JITTER');
figure1 = [xpl_file_name,'_CDF of TCP\_RX\_JITTER.fig'];
% saveas(a1,figure1);

% figure2 is the histogram
figure(2);
% a2 = [xpl_file_name,'2'];
% figure(a2);
CDF_TCP_TX_DIFF_HIST = hist(CDF_of_diff_TCP_TX_time);
CDF_TCP_TX_JITTER = cumsum(CDF_TCP_TX_DIFF_HIST/length(CDF_of_diff_TCP_TX_time));
plot(CDF_TCP_TX_JITTER,'-b');
hold on;
axis square;
grid on;
xlabel('Delta\_T\_of\_TCP\_TX\_DATA (seconds)');
ylabel('CDF');
title('CDF of TCP\_TX\_JITTER');
figure2 = [xpl_file_name,'_CDF of TCP\_TX\_JITTER.fig'];
% saveas(a2,figure2);


% figure3 is the histogram
figure(3);
% a3 = [xpl_file_name,'3'];
% figure(a3);
h = hist(OCC(:,1));
CDF = cumsum(h/length(OCC));
plot(CDF,'-m');
hold on;
axis square;
grid on;
xlabel('Delay (seconds)');
ylabel('CDF');
title('CDF of (TCP\_RX\_time - TCP\_TX\_time)');
figure3 = [xpl_file_name,'_CDF of (TCP\_RX\_time - TCP\_TX\_time).fig'];
% saveas(a3,figure3);

% figure4 is the Unusual numbers of packets VS dalay
figure(4);
% a4 = [xpl_file_name,'4'];
% figure(a4);
x = OOO_DATA_calculated(:,1);
y = OOO_DATA_calculated(:,2);
plot(x,y,'or');
hold on;
axis square;
% axis([0 20 0 3]);
grid on;
xlabel('Out\_of\_order dalay (seconds)');
ylabel('Out\_of\_order block numbers (1388bytes per block)');
title('OOO block numbers VS OOO dalay');
figure4 = [xpl_file_name,'_OOO block numbers VS OOO dalay.fig'];
% saveas(a4,figure4);

disp('...all the figure have been printed')

% output all the matrix into a big cell
pre_output{1,1} = CDF_TCP_RX_JITTER;
pre_output{1,2} = CDF_TCP_TX_JITTER;
pre_output{1,3} = CDF;
pre_output{1,4} = OOO_DATA_calculated;

disp('Program finished')

end
