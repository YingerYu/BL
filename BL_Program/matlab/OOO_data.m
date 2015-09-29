%%%---------------------------------------------------------------------------------------------%%%
%%% Filename: pre.m                                                                       %%%
%%% Description: Data Analysis
%%%
% Analyze the Tcptrace data and plot the figures.
%%%---------------------------------------------------------------------------------------------%%%


function OOO_output = OOO_data(xpl_file_name, bins)
% close all
% clear all
% clc

% Define and initialize the parameters that used in this function
block_size = 1388; % define the block size for seq# (LTE)
% block_size = 1390; % define the block size for seq# (small_cell)
VariMax = 2; % define 2 types of data, time & sequence number
TCP_RX_data_blank = zeros(0,VariMax); % save all lines into a matrix
TCP_RX_data_u = zeros(0,VariMax); % save all lines into a matrix with u
TCP_RX_data_ud = zeros(0,VariMax); % save all lines into a matrix with u or d
TCP_RX_data = []; % all useful data with matrix

% Read the local file to analysis the data
fid1 = fopen(xpl_file_name);

% Create a file to save the data
output_name = [xpl_file_name,'_OOO_DATA_Output.txt'];
save(output_name);
fid2 = fopen(output_name, 'w', 'n', 'utf-8'); 

% Set the expr to select useful informations
expr_u = 'uarrow'; % white arrow's 2nd line begin with "uarrow"
expr_d = 'darrow'; % white arrow's 1st line begin with "darrow"
expr_space = '\ '; % space
% expr4 = 'green'; % green line
% expr5 = 'line'; % line

disp('Loading the file and matching the useful data...')
% Set the file line by line
SeqN_u = 0;
last_SeqN_u = 0;
SeqN_d = 0;
last_SeqN_d = 0;

tline = fgets(fid1);
while ischar(tline)
%     disp(tline)
    if ~isempty(tline) % delete the empty lines
        data_split = regexp(tline, expr_space, 'split');
        match_value_u = strcmp(data_split{1},expr_u);
        match_value_d = strcmp(data_split{1},expr_d);
        
        if (match_value_u == 1)
            TCP_RX_data_ud(end+1,1) = str2num(data_split{2});
            TCP_RX_data_u(end+1,1) = str2num(data_split{2});
            SeqN_u = str2num(data_split{3}); 
            if ((SeqN_u+2^31) < last_SeqN_u)
                SeqN_u = SeqN_u + (2^32 - 1);
            end
            last_SeqN_u = SeqN_u;
            TCP_RX_data_ud(end,2) = SeqN_u;       
            TCP_RX_data_u(end,2) = SeqN_u;       
        elseif (match_value_d == 1)
            TCP_RX_data_ud(end+1,1) = str2num(data_split{2});
            SeqN_d = str2num(data_split{3}); 
            if ((SeqN_d+2^31) < last_SeqN_d)
                SeqN_d = SeqN_d + (2^32 - 1);
            end
            last_SeqN_d = SeqN_d;
            TCP_RX_data_ud(end,2) = SeqN_d;
        end
    end
    tline = fgets(fid1);
end
fclose(fid1);

% Fill all of the blanks
TCP_RX_data_ud_sort = sortrows(TCP_RX_data_ud,2);
for udcount = 2 : 1 : (length(TCP_RX_data_ud_sort)-1)
    if (TCP_RX_data_ud_sort(udcount,1)~=TCP_RX_data_ud_sort((udcount-1),1)&&TCP_RX_data_ud_sort(udcount,1)~=TCP_RX_data_ud_sort((udcount+1),1))
       if (TCP_RX_data_ud_sort(udcount,2)~=TCP_RX_data_ud_sort((udcount-1),2)&&TCP_RX_data_ud_sort(udcount,2)~=TCP_RX_data_ud_sort((udcount+1),2))
           TCP_RX_data_blank(end+1,1) = TCP_RX_data_ud_sort((udcount-1),1);
           TCP_RX_data_blank(end,2) = TCP_RX_data_ud_sort(udcount,2);
       end
    end
end
TCP_RX_data = [TCP_RX_data_blank; TCP_RX_data_u];

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
    if (TCP_RX_data_sort(scount,2) ~= TCP_RX_data_sort((scount+1),2) && TCP_RX_data_sort(scount,1) ~= TCP_RX_data_sort((scount+1),1))
        if (TCP_RX_data_sort(scount,1) > TCP_RX_data_sort((scount+1),1))
            fprintf('Found the unusual data at sequence# %d at %8fs \n',TCP_RX_data_sort(scount,2),TCP_RX_data_sort(scount,1));
            fprintf(fid2,'Found the unusual data at sequence# %d at %8fs \n',TCP_RX_data_sort(scount,2),TCP_RX_data_sort(scount,1));
            for ncount = 1 : 1 : scount
                if (TCP_RX_data_sort((scount+1),1)>TCP_RX_data_sort((scount-ncount),1) )
                    delta_seq  = TCP_RX_data_sort(scount,2) - TCP_RX_data_sort((scount-ncount),2);
                    delta_time = TCP_RX_data_sort(scount,1) - TCP_RX_data_sort((scount-ncount),1);
                    pkt_block  = delta_seq/block_size;
                    if (pkt_block >= 1 && delta_time > 0)
                        OOO_DATA_calculated(count,1) = delta_time;
                        OOO_DATA_calculated(count,2) = pkt_block;
                        count = count + 1;
                        if (delta_seq/block_size > 1)
                            fprintf('%d packets have been delayed for %4fs\n',delta_seq/block_size,delta_time);
                            fprintf(fid2,'%d packets have been delayed for %4fs\n',delta_seq/block_size,delta_time);
                        else
                            fprintf('%d packet has been delayed for %4fs\n',delta_seq/block_size,delta_time);
                            fprintf(fid2,'%d packet has been delayed for %4fs\n',delta_seq/block_size,delta_time);
                        end
                    end
                    break
                end
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
% clf
% x1rx = TCP_RX_data(:,1);
% y1rx = TCP_RX_data(:,2);
% 
% x1tx = TCP_TX_data(:,1);
% y1tx = TCP_TX_data(:,2);
% hold on
% plot(x1rx - TCP_RX_data(1),y1rx,'.b'); 
% plot(x1tx - TCP_TX_data(1),y1tx,'r');    % TCP TX
% hold off
% axis square;
% grid on;
% xlabel('Time (seconds)');
% ylabel('Seq# (sequence numbers)');

% figure1 is the CDF_TCP_RX_JITTER
% figure(1);
CDF_TCP_RX_DIFF_HIST = hist(CDF_of_diff_TCP_RX_time, bins);
CDF_TCP_RX_JITTER = cumsum(CDF_TCP_RX_DIFF_HIST/length(CDF_of_diff_TCP_RX_time));
% semilogx(bins, CDF_TCP_RX_JITTER,'-g');
% hold on;
% axis square;
% grid on;
% xlabel('Delta\_T\_of\_TCP\_RX\_DATA (seconds)');
% ylabel('CDF');
% title('CDF of TCP\_RX\_JITTER');
% % figure1 = [xpl_file_name,'_CDF of TCP\_RX\_JITTER.fig'];

% figure2 is the histogram
% figure(2);
CDF_TCP_TX_DIFF_HIST = hist(CDF_of_diff_TCP_TX_time, bins);
CDF_TCP_TX_JITTER = cumsum(CDF_TCP_TX_DIFF_HIST/length(CDF_of_diff_TCP_TX_time));
% semilogx(bins, CDF_TCP_TX_JITTER,'-b');
% hold on;
% axis square;
% grid on;
% xlabel('Delta\_T\_of\_TCP\_TX\_DATA (seconds)');
% ylabel('CDF');
% title('CDF of TCP\_TX\_JITTER');
% % figure2 = [xpl_file_name,'_CDF of TCP\_TX\_JITTER.fig'];


% figure3 is the histogram
% figure(3);
h = hist(OCC(:,1), bins);
CDF = cumsum(h/length(OCC));
% semilogx(bins, CDF,'-m');
% hold on;
% axis square;
% grid on;
% xlabel('Delay (seconds)');
% ylabel('CDF');
% title('CDF of (TCP\_RX\_time - TCP\_TX\_time)');
% figure3 = [xpl_file_name,'_CDF of (TCP\_RX\_time - TCP\_TX\_time).fig'];

% figure4 is the Unusual numbers of packets VS dalay
figure(4);
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
% figure4 = [xpl_file_name,'_OOO block numbers VS OOO dalay.fig'];


disp('...all the figure have been printed')

% output all the matrix into a big cell
OOO_output{1,1} = CDF_TCP_RX_JITTER;
OOO_output{1,2} = CDF_TCP_TX_JITTER;
OOO_output{1,3} = CDF;
OOO_output{1,4} = OOO_DATA_calculated;

end
