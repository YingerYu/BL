%%%---------------------------------------------------------------------------------------------%%%
%%% Filename: pre.m                                                                       %%%
%%% Description: Data Analysis
%%%
% Analyze the Tcptrace data and plot the figures.
%%%---------------------------------------------------------------------------------------------%%%

function main()
close all
clear all
clc

% Define and initialize the parameters that used in this function
VariMax = 2; % define 2 types of data, time & sequence number
tlines = cell(0,VariMax); % save all lines into a cell

% Read the local file to analysis the data
fid1 = fopen('test.xpl');
fid2 = fopen('output.txt', 'w', 'n', 'Shift_JIS');

% Set the expr to select useful informations
expr1 = 'darrow'; % white arrow's first line
expr2 = '\ '; % space

disp('Loading the file and matching the useful data...')
% Set the file line by line
tline = fgets(fid1);

while ischar(tline)
%     disp(tline)
    if ~isempty(tline) % delete the empty lines
        convert1 = regexp(tline, expr2, 'split');
        compare = strcmp(convert1{1},expr1);
        if (compare == 1)
            tlines{end+1,1} = str2num(convert1{2});
            tlines{end,2} = str2num(convert1{3});
        end
    end
    tline = fgets(fid1);
end
fclose(fid1);
disp('...useful data has been matched')

disp('Finding the unusual data...')
list = sortrows(tlines,2); % sort all data in rows
disp('Calculating the number of unusual data and delay')
disp('**********************************************************************************************')
fprintf(fid2,'**********************************************************************************************\n');
% Output the data for plot the figure
Output = cell(0, VariMax);
count = 1;
for scount = 1 : 1 : (length(list)-1)
    if (list{scount,1} > list{(scount+1),1})
        fprintf('Found the unusual data from seqence# %d to seqence# %d at %8fs \n',list{scount,2},list{(scount+1),2},list{scount,1});
        fprintf(fid2,'Found the unusual data from seqence# %d to seqence# %d at %8fs \n',list{scount,2},list{(scount+1),2},list{scount,1});
        delta_seq = list{(scount+1),2} - list{scount,2};
        delta_time = list{scount,1} - list{(scount-1),1};
        Output{count,1} = delta_time;
        Output{count,2} = delta_seq;
        count = count + 1;
        fprintf('%d packets has been delayed for %4fs\n',delta_seq,delta_time);
        fprintf(fid2,'%d packets has been delayed for %4fs\n',delta_seq,delta_time);
    end
end
fprintf(fid2,'**********************************************************************************************\n');
disp('**********************************************************************************************')
disp('...all unusual data has been founded')

disp('Ploting the figure...')
% % Plot figure
figure(1);
for fcount = 1 : 1 : (length(Output)/2)
    x = Output{fcount,1};
    y = Output{fcount,2};
    plot(x,y,'or');
    hold on;
    axis square;
end
% % axis([-100 1100 -100 1100]);
grid on;
xlabel('Delta\_time (unusual packets dalay in second)');
ylabel('Delta\_seq# (unusual packets numbers)');
title('Unusual numbers of packets VS dalay');
disp('...figure has been printed')
disp('Program finished')

end
