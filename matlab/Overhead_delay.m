%%---------------------------------------------------------------------------------------------%%
% Filename: Overhead_delay.m
% Function program
% Description: 
% Data Analysis for overhead verous delay; 
% Compute the overhead of each out of order packets and for each out of number packets group, how much delay of them
%%---------------------------------------------------------------------------------------------%%


function OH_DD = Overhead_delay(xpl_file_name)

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
CDF_of_diff_TCP_RX_time = diff(TCP_RX_data_sort_t(:,1));
CDF_of_diff_TCP_TX_time = diff(TCP_TX_data(:,1));
% OCC = TCP_TX_data - TCP_RX_data_sort_s;
% OCC = cummax((TCP_TX_data - cell2mat(TCP_RX_data_sort))/(TCP_TX_data(end,2)-TCP_TX_data(1,2)));

disp('Calculating overhead of unusual data and delay')
disp('**********************************************************************************************')

% Calculate the matched data for plot the figure
OOO_DATA_calculated = zeros(0, VariMax);
Overhead_100        = zeros(0, VariMax);
Overhead_0          = zeros(0, VariMax);
Reference_ratio     = zeros(0, 1);

count = 1;
for scount = 1 : 1 : (length(TCP_RX_data_sort_s)-1)
    if (TCP_RX_data_sort_s(scount,2) ~= TCP_RX_data_sort_s((scount+1),2) && TCP_RX_data_sort_s(scount,1) ~= TCP_RX_data_sort_s((scount+1),1))
        if (TCP_RX_data_sort_s(scount,1) > TCP_RX_data_sort_s((scount+1),1))
            fprintf('Found the unusual data at sequence# %d at %8fs \n',TCP_RX_data_sort_s(scount,2),TCP_RX_data_sort_s(scount,1));
            for ncount = 1 : 1 : scount
                if (TCP_RX_data_sort_s((scount+1),1)>TCP_RX_data_sort_s((scount-ncount),1) )
                    delta_seq  = TCP_RX_data_sort_s(scount,2) - TCP_RX_data_sort_s((scount-ncount),2);
                    delta_time = TCP_RX_data_sort_s(scount,1) - TCP_RX_data_sort_s((scount-ncount),1);
                    pkt_block  = delta_seq/block_size;
                    if (pkt_block >= 1 && delta_time > 0)
                        OOO_DATA_calculated(count,1) = delta_time;
                        OOO_DATA_calculated(count,2) = pkt_block;
                        count = count + 1;
                        if (delta_seq/block_size > 1)
                            fprintf('%d packets have been delayed for %4fs\n',delta_seq/block_size,delta_time);
                        else
                            fprintf('%d packet has been delayed for %4fs\n',delta_seq/block_size,delta_time);
                        end
                        Last_IO_time      = TCP_RX_data_sort_s((scount-ncount),1);
                        Last_IO_seq       = TCP_RX_data_sort_s((scount-ncount),2);
                        Again_IO_index    = find(TCP_RX_data_sort_t(:,1) == TCP_RX_data_sort_s((scount),1));
                        if ~isempty(Again_IO_index) 
                            Again_IO_index_new = min(Again_IO_index);
                            Again_IO_time      = TCP_RX_data_sort_t((Again_IO_index_new+1),1);
                            Again_IO_seq       = TCP_RX_data_sort_t((Again_IO_index_new+1),2);
                            IO_ratio           = (Again_IO_seq-Last_IO_seq)/(Again_IO_time-Last_IO_time);
                        end
                        % 100% miss is scan from the last_IO_pkts, the
                        % first reference time larger than real time,
                        % means the packets already arrived.
                        again_scount = find(TCP_RX_data_sort_s(:,2)==Again_IO_seq, 1, 'last' );
                        for ocount = (scount-ncount+1) : 1 : (again_scount-1) % from 1st to last
                            reference_time_o = (TCP_RX_data_sort_s(ocount,2)-Last_IO_seq)/IO_ratio+Last_IO_time;
                            real_time_o      = TCP_RX_data_sort_s(ocount,1);
                            if (reference_time_o >= real_time_o)
                                Overhead_100(end+1,1) = (TCP_RX_data_sort_s((ocount-2),2) - Last_IO_seq)/IO_ratio; % 100% delay
                                Overhead_100(end,2)   = (TCP_RX_data_sort_s((ocount-2),2) - Last_IO_seq)/block_size; % 100% BS
                                All_data_below_ref = 0;                                    
                                break
                            else
                                All_data_below_ref = 1;
                                Overhead_100(end+1,1) = (TCP_RX_data_sort_s((again_scount-1),2) - Last_IO_seq)/IO_ratio; % 100% delay
                                Overhead_100(end,2)   = (TCP_RX_data_sort_s((again_scount-1),2) - Last_IO_seq)/block_size; % 100% BS
                                Overhead_0(end+1,1)   = (Again_IO_time - Last_IO_time); % 0% delay
                                Overhead_0(end,2)     = (Again_IO_seq - Last_IO_seq)/block_size; % 0% BS
                                Reference_ratio(end+1,1) = IO_ratio; % Reference ratio
                                break
                            end
                        end
                        % 0% miss is scan from the Again_last_IO_pkts, the
                        % first reference time smaller than real time,
                        % means the packets missed.
                        for hcount = (again_scount-1): (-1) : (scount-ncount+1) % from last to 1st
                            reference_time_h = (TCP_RX_data_sort_s(ocount,2)-Last_IO_seq)/IO_ratio+Last_IO_time;
                            real_time_h      = TCP_RX_data_sort_s(hcount,1);
                            if (All_data_below_ref ~=1)
                                if (reference_time_h <= real_time_h)
                                    Overhead_0(end+1,1)   = (TCP_RX_data_sort_s((hcount+1),2) - Last_IO_seq)/IO_ratio; % 0% delay
                                    Overhead_0(end,2)     = (TCP_RX_data_sort_s((hcount+1),2) - Last_IO_seq)/block_size; % 0% BS
                                    Reference_ratio(end+1,1) = IO_ratio;
                                    break
                                else
                                    Overhead_0(end+1,1)   = (TCP_RX_data_sort_s((scount-ncount+1),2) - Last_IO_seq)/IO_ratio; % 0% delay
                                    Overhead_0(end,2)     = (TCP_RX_data_sort_s((scount-ncount+1),2) - Last_IO_seq)/block_size; % 0% BS
                                    Reference_ratio(end+1,1) = IO_ratio;
                                    break                                        
                                end                                    
                            end    
                        end
                    end                
                    break
                end
            end
        end
    end
end
disp('**********************************************************************************************')
disp('...Overhead and delay deadline have been analysed, and have been saved in a cell')


% output file for each xpl file
OH_DD = [Reference_ratio,Overhead_100,Overhead_0];

end