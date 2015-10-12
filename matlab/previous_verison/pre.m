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

tlines = cell(0,1); % save all lines into a cell
tlines1 = cell(0,1); % save the useful data into a cell
tlines2 = cell(0,1); % save the useful data into a cell

% Read the local file to analysis the data
fid1 = fopen('test.xpl');

% Set the expr to select useful informations
expr1 = 'darrow.*';
expr2 = '(?<=\w+)\d+'; % only the numbers
expr3 = '\ '; % space
replace = '\,'; 

% Set the file line by line
tline = fgets(fid1);

while ischar(tline)
%     disp(tline)
    if ~isempty(tline) % delete the empty lines
        tlines{end+1,1} = tline;
    end
    tlines1 = regexprep(tlines,expr3,replace);
    tline = fgets(fid1);
end
fclose(fid1);

% Find the tlines with expression on them
eqnLines1 = regexp(tlines1,expr1,'match');
eqnLineMask = ~cellfun(@isempty, eqnLines1);
for seq = 1 : 1 : length(eqnLines1)
    if (eqnLineMask(seq) ~= 0)
        a = eqnLines1(seq);
        b = regexp(a{1}, replace, 'split');
        tlines2{end+1,1} = b;
    end
end

% Output the useful information into a cell array
list = cell(length(tlines2), VariMax);
list{length(tlines2), VariMax} = [];
list_new = cell(length(tlines2), VariMax);
list_new{length(tlines2), VariMax} = [];
for scount = 1 : 1 : length(tlines2)
    for tcount = 1 : 1 : VariMax
        list{scount,tcount} = str2num(tlines2{scount}{1}{tcount+1});
    end
end
list_new = sortrows(list,2); % sort all data in rows

% Output the data for plot the figure
Output = cell(0, VariMax);
count = 1;
for scount = 1 : 1 : (length(list_new)-1)
%     % Debug
%     y = list_new{(scount+1),1} - list_new{scount,1};
%     u = list_new{(scount+1),2} - list_new{scount,2};
    if (list_new{scount,1} > list_new{(scount+1),1})
        fprintf('Found the unusual data from seqence# %d to seqence# %d at %8fs \n',list_new{scount,2},list_new{(scount+1),2},list{scount,1});
        delta_seq = list_new{(scount+1),2} - list_new{scount,2};
        delta_time = list_new{scount,1} - list_new{(scount-1),1};
        Output{count,1} = delta_time;
        Output{count,2} = delta_seq;
        count = count + 1;
    end
end


% % Plot figure
figure(1);
for fcount = 1 : 1 : (length(Output)/2)
    x = Output{fcount,1};
    y = Output{fcount,2};
    plot(x,y,'sr');
    hold on;
    axis square;
end
% % axis([-100 1100 -100 1100]);
grid on;
xlabel('Delta_time (unusual packets dalay in second)');
ylabel('Delta_seq# (unusual packets numbers)');
title('Unusual numbers of packets VS dalay');

end
