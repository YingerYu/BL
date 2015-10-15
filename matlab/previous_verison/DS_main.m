%%---------------------------------------------------------------------------------------------%%
% Filename: DS_main.m
% Main program
% Description: Data Analysis for duration verous OOO pkts; 
% Input: the list of each xpl file of each scenario (line 13)
%%---------------------------------------------------------------------------------------------%%

close all
clear all
clc

% Read the list file
fileID = fopen('/home/mina/Desktop2/yu/data/EBC/1UE---handover/list.txt');
file_list_name = textscan(fileID,'%s');
file_list = file_list_name{1};
fclose(fileID);

% Store all the data for each scenario
Du_Sum_total = [];
REC = [];
scenario_index=1;
xpl_index = 0;

% main loop, call the Duration_SumOOO function
for file_count = 1 : 1 : length(file_list)
    xpl_file_name = file_list{file_count};
    if (xpl_file_name == '#')
        scenario_index = scenario_index+1;
        xpl_index = 0;
    end
    if (xpl_file_name ~= '#')
        xpl_index = xpl_index+1;   
        Du_Sum = Duration_SumOOO(xpl_file_name);
        if ~isempty(Du_Sum)
            Du_Sum_total = [Du_Sum_total;Du_Sum{1}];        
            REC(scenario_index).DATA{xpl_index} = Du_Sum{2};
            save([file_list{file_count} '_Duration_Sum'], '-mat','Du_Sum');
        end
        disp('---------------------------------------------');
        fprintf('No.%d (%s) has been completed.\n',file_count,xpl_file_name);
        disp('---------------------------------------------');
    end
end
save('/home/mina/Desktop2/yu/BL/matlab/Duration_SumOOO.mat','Du_Sum_total');
save('/home/mina/Desktop2/yu/BL/matlab/REC_OOO_area.mat','REC');


disp(' ')
disp('#########################################################')
disp(' ')
disp('Program has been successfully completed')
disp(' ')
disp('#########################################################')

