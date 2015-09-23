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
data_matched = cell(0,VariMax); % save all lines into a cell

% Read the local file to analysis the data
fid1 = fopen('p2o_tsg.xpl');
% Create a file to save the data
fid2 = fopen('output.txt', 'w', 'n', 'Shift_JIS'); 

% Set the expr to select useful informations
expr1 = 'darrow'; % white arrow's first line begin with "darrow"
expr2 = '\ '; % space

disp('Loading the file and matching the useful data...')
% Set the file line by line
tline = fgets(fid1);
while ischar(tline)
%     disp(tline)
    if ~isempty(tline) % delete the empty lines
        data_split = regexp(tline, expr2, 'split');
        match_value = strcmp(data_split{1},expr1);
        if (match_value == 1)
            data_matched{end+1,1} = str2num(data_split{2});
            data_matched{end,2} = str2num(data_split{3});
        end
    end
    tline = fgets(fid1);
end
fclose(fid1);
data_matched_plot = cell2mat(data_matched); % convert the matched data for plot figure

disp('...useful data has been matched')

disp('Finding the unusual data...')
list = sortrows(data_matched,2);% sort all data in rows and put them into list cell
list_cummax = cummax(cell2mat(list));
OCC = list_cummax - cell2mat(list);

disp('Calculating the number of unusual data and delay')
disp('**********************************************************************************************')
fprintf(fid2,'**********************************************************************************************\n');
% Calculate the matched data for plot the figure
Output = cell(0, VariMax);
count = 1;
for scount = 1 : 1 : (length(list)-1)
    if (list{scount,1} > list{(scount+1),1})
        fprintf('Found the unusual data from sequence# %d to sequence# %d at %8fs \n',list{scount,2},list{(scount+1),2},list{scount,1});
        fprintf(fid2,'Found the unusual data from sequence# %d to sequence# %d at %8fs \n',list{scount,2},list{(scount+1),2},list{scount,1});
        delta_seq = list{(scount+1),2} - list{scount,2};
        delta_time = list{scount,1} - list{(scount-1),1};
        Output{count,1} = delta_time;
        Output{count,2} = delta_seq/1388;
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
% % Plot figure1 for the tcptrace
figure(1);
x1 = data_matched_plot(:,1);
y1 = data_matched_plot(:,2);
plot(x1,y1,'.b');
hold on;
axis square;
grid on;
xlabel('Time (seconds)');
ylabel('Seq# (sequence numbers)');

% figure2 is the Unusual numbers of packets VS dalay
figure(2);
Output_plot = cell2mat(Output);
x = Output_plot(:,1);
y = Output_plot(:,2);
plot(x,y,'or');
hold on;
axis square;
axis([0 10 0 3]);
grid on;
xlabel('Unusual packets dalay (seconds)');
ylabel('Unusual packets numbers (1388bytes per packet)');
title('Unusual numbers of packets VS dalay');

% figure3 is the histogram
figure(3);
% hist(OCC(:,1),0:0.1:10)
histogram(OCC(:,1),0:0.1:10)
hold on;
axis square;
grid on;
xlabel('Delay (seconds)');
ylabel('OCC#');

disp('...all the figure have been printed')
disp('Program finished')

% end
