%%%---------------------------------------------------------------------------------------------%%%
%%% Filename: pre.m                                                                       %%%
%%% Description: Data Analysis for overhead and delay deadline
%%%
% Analyze the overhead and the delay deadline.
%%%---------------------------------------------------------------------------------------------%%%


function Du_Sum = Duration_SumOOO(xpl_file_name)
% close all
% clear all
% clc

% Define and initialize the parameters that used in this function
block_size = 1388; % define the block size for seq# (LTE)
% block_size = 5; % for test
VariMax = 2; % define 2 types of data, time & sequence number
TCP_RX_data_blank = zeros(0,VariMax); % save all lines into a matrix
TCP_RX_data_u = zeros(0,VariMax); % save all lines into a matrix with u
TCP_RX_data_ud = zeros(0,VariMax); % save all lines into a matrix with u or d
TCP_RX_data = []; % all useful data with matrix

% Read the local file to analysis the data
% fid1 = fopen(xpl_file_name);
fid1 = fopen(xpl_file_name);

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
    if (TCP_RX_data_ud_sort(udcount,2)~=TCP_RX_data_ud_sort((udcount-1),2)&&TCP_RX_data_ud_sort(udcount,2)~=TCP_RX_data_ud_sort((udcount+1),2))
       if (TCP_RX_data_ud_sort(udcount,1)~=TCP_RX_data_ud_sort((udcount-1),1)&&TCP_RX_data_ud_sort(udcount,1)==TCP_RX_data_ud_sort((udcount+1),1))
           TCP_RX_data_blank(end+1,1) = TCP_RX_data_ud_sort((udcount-1),1);
           TCP_RX_data_blank(end,2) = TCP_RX_data_ud_sort(udcount,2);
       end
    end
end
TCP_RX_data = [TCP_RX_data_blank; TCP_RX_data_u];

disp('...useful data has been matched')

disp('Finding the unusual data...')
TCP_RX_data_sort_t = sortrows(TCP_RX_data,1);% follow the time to sort all data in rows and put them into TCP_RX_data_sort_t cell
TCP_RX_data_sort_s = sortrows(TCP_RX_data,2);% follow the seq# to sort all data in rows and put them into TCP_RX_data_sort_s cell
TCP_TX_data = cummax(TCP_RX_data_sort_s);
% CDF_of_diff_TCP_RX_time = diff(TCP_RX_data_sort_t(:,1));
% CDF_of_diff_TCP_TX_time = diff(TCP_TX_data(:,1));
% OCC = TCP_TX_data - TCP_RX_data_sort_s;
% OCC = cummax((TCP_TX_data - cell2mat(TCP_RX_data_sort))/(TCP_TX_data(end,2)-TCP_TX_data(1,2)));

% Calculate the matched data for plot the figure
% OOO_DATA_calculated = zeros(0, VariMax);
% Overhead_100        = zeros(0, VariMax);
% Overhead_0          = zeros(0, VariMax);
% Reference_ratio     = zeros(0, 1);
% Overhead = zeros(0, VariMax);
count = 0;
for scount = 1 : 1 : (length(TCP_RX_data_sort_s)-1)
    if (TCP_RX_data_sort_s(scount,2) ~= TCP_RX_data_sort_s((scount+1),2) && TCP_RX_data_sort_s(scount,1) ~= TCP_RX_data_sort_s((scount+1),1))
        if (TCP_RX_data_sort_s(scount,1) > TCP_RX_data_sort_s((scount+1),1))
            count = count + 1;
            fprintf('Found the %dth data at sequence# %d at %8fs \n',count,TCP_RX_data_sort_s(scount,2),TCP_RX_data_sort_s(scount,1));
        end
    end
end
duration = TCP_RX_data_sort_t(length(TCP_RX_data_sort_t),1)-TCP_RX_data_sort_t(1,1);

disp('**********************************************************************************************')
fprintf('In total, ( %d ) OOO_data happend at %f4s duration',count, duration);
disp('**********************************************************************************************')


Du_Sum = [duration,count,(duration/count)];

end