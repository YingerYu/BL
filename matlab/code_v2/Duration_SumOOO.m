%%---------------------------------------------------------------------------------------------%%
% Filename: Duration_SumOOO.m
% Function program
% Description: 
% Data Analysis for duration verous OOO pkts; 
% compute the total number of out of order packets groups and for each xpl file, how much time of the total duration
%%---------------------------------------------------------------------------------------------%%


function Du_Sum = Duration_SumOOO(xpl_file_name)

% Define and initialize the parameters that used in this function
block_size = 1388; % define the block size for seq#
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

% Compute the total number of out of order packets and the total duration
% for each xpl file
count = 0;
% There are four column in this matrix, 1st is the last io time, 2nd is the last io seq; 3rd is again io time, 4th is again io seq 
OOO_area = zeros(0,4);

for scount = 1 : 1 : (length(TCP_RX_data_sort_s)-1)
    if (TCP_RX_data_sort_s(scount,2) ~= TCP_RX_data_sort_s((scount+1),2) && TCP_RX_data_sort_s(scount,1) ~= TCP_RX_data_sort_s((scount+1),1))
        if (TCP_RX_data_sort_s(scount,1) > TCP_RX_data_sort_s((scount+1),1))
            fprintf('Found the unusual data at sequence# %d at %8fs \n',TCP_RX_data_sort_s(scount,2),TCP_RX_data_sort_s(scount,1));
            for ncount = 1 : 1 : scount
                if (TCP_RX_data_sort_s((scount+1),1)>TCP_RX_data_sort_s((scount-ncount),1) )
                    count = count + 1;
                    Last_IO_time      = TCP_RX_data_sort_s((scount-ncount),1);
                    Last_IO_seq       = TCP_RX_data_sort_s((scount-ncount),2);
                    Again_IO_index    = find(TCP_RX_data_sort_t(:,1) == TCP_RX_data_sort_s((scount),1));
                    if ~isempty(Again_IO_index) 
                        Again_IO_index_new = min(Again_IO_index);
                        Again_IO_time      = TCP_RX_data_sort_t((Again_IO_index_new+1),1);
                        Again_IO_seq       = TCP_RX_data_sort_t((Again_IO_index_new+1),2);
                    end
                    OOO_area(end+1,1) = Last_IO_time;
                    OOO_area(end,2)   = Last_IO_seq;
                    OOO_area(end,3)   = Again_IO_time;
                    OOO_area(end,4)   = Again_IO_seq;
                    break
                end
            end
        end
    end
end

duration = TCP_RX_data_sort_t(length(TCP_RX_data_sort_t),1)-TCP_RX_data_sort_t(1,1);
total_seq = TCP_RX_data_sort_s(length(TCP_RX_data_sort_s),2)-TCP_RX_data_sort_s(1,2);

% output file for each xpl file
Du_Sum{1,1} = [duration,total_seq];
Du_Sum{1,2} = OOO_area;
end