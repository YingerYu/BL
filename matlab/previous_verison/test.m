% function main()
close all
clear all
clc

% a = cell(0, 2);
% 
% for acount = 1 : 1 : 10
%     a{acount, 1} = acount;    
%     a{acount, 2} = 21-acount;
% end
% 
% list_new = sortrows(a,2);
% 
% figure(1);
% for fcount = 1 : 1 : length(list_new)
%     x = list_new{fcount,1};
%     y = list_new{fcount,2};
%     plot(x,y,'*r');
%     hold on;
%     axis square;
% end
% % % axis([-100 1100 -100 1100]);
% grid on;
% xlabel('Delta_time (unusual packets dalay in second)');
% ylabel('Delta_seq# (unusual packets numbers)');
% title('Unusual packets numbers VS dalays');
% 
% figure(2);
% % hist(cell2mat(list_new));
% histogram(cell2mat(list_new(:,1)));
% 
% end

% Define and initialize the parameters that used in this function
block_size = 1388; % define the block size for seq# (LTE)
% block_size = 1390; % define the block size for seq# (small_cell)
VariMax = 2; % define 2 types of data, time & sequence number
TCP_RX_data_blank = zeros(0,VariMax); % save all lines into a matrix
TCP_RX_data_u = zeros(0,VariMax); % save all lines into a matrix with u
TCP_RX_data_ud = zeros(0,VariMax); % save all lines into a matrix with u or d
TCP_RX_data = [];
% Read the local file to analysis the data
fid1 = fopen('/home/mina/Desktop2/yu/BL/BL_Program/matlab/previous_verison/test_database/test_blank.xpl');

% Set the expr to select useful informations
expr1 = 'uarrow'; % white arrow's first line begin with "darrow"
expr3 = 'darrow'; % white arrow's first line begin with "darrow"
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
        match_value_u = strcmp(data_split{1},expr1);
        match_value_d = strcmp(data_split{1},expr3);
        
        if (match_value_u == 1)
            TCP_RX_data_ud(end+1,1) = str2num(data_split{2});
            TCP_RX_data_u(end+1,1) = str2num(data_split{2});
            SeqN = str2num(data_split{3}); 
            if ((SeqN+2^31) < last_SeqN)
                SeqN = SeqN + (2^32 - 1);
            end
            last_SeqN = SeqN;
            TCP_RX_data_ud(end,2) = SeqN;       
            TCP_RX_data_u(end,2) = SeqN;       
        elseif (match_value_d == 1)
            TCP_RX_data_ud(end+1,1) = str2num(data_split{2});
            SeqN = str2num(data_split{3}); 
            if ((SeqN+2^31) < last_SeqN)
                SeqN = SeqN + (2^32 - 1);
            end
            last_SeqN = SeqN;
            TCP_RX_data_ud(end,2) = SeqN;
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