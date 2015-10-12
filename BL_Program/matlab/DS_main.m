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
fileID = fopen('/home/mina/Desktop2/xxx/xxx/xxx/list.txt');
file_list_name = textscan(fileID,'%s');
file_list = file_list_name{1};
fclose(fileID);

Du_Sum_total = [];

for file_count = 1 : 1 : length(file_list)
    xpl_file_name = file_list{file_count};
    Du_Sum = Duration_SumOOO(xpl_file_name);
%     Du_Sum_1 = [xpl_file_name,Du_Sum];
    save([file_list{file_count} '_Duration_Sum'], '-mat','Du_Sum');
    if ~isempty(Du_Sum)
        Du_Sum_total = [Du_Sum_total;Du_Sum];
    end
    disp('---------------------------------------------');
    fprintf('No.%d (%s) has been completed.\n',file_count,xpl_file_name);
    disp('---------------------------------------------');
end
save('/home/mina/Desktop2/yu/BL/BL_Program/matlab/Duration_SumOOO.mat','Du_Sum_total');

disp(' ')
disp('#########################################################')
disp(' ')
disp('Program has been successfully completed')
disp(' ')
disp('#########################################################')

