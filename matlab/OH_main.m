%%---------------------------------------------------------------------------------------------%%
% Filename: OH_main.m
% Main program
% Description: Data Analysis for overhead verous delay; 
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

% Store all the data for each scenario
OH_DD_total = [];

% main loop, call the Overhead_delay function
for file_count = 1 : 1 : length(file_list)
    xpl_file_name = file_list{file_count};
    if (xpl_file_name ~= '#')
        OH_DD = Overhead_delay(xpl_file_name);
        save([file_list{file_count} '_OH_DD'], '-mat','OH_DD');
        if ~isempty(OH_DD)
            OH_DD_total = [OH_DD_total;OH_DD];
        end
        disp('---------------------------------------------');
        fprintf('No.%d (%s) has been completed.\n',file_count,xpl_file_name);
        disp('---------------------------------------------');
    end
end
save('/home/mina/Desktop2/yu/BL/matlab/OH_DD_total.mat','OH_DD_total');
        
% figure21 is the scatter figure of reference ratio verous deadline delay
figure(21);
scatter(OH_DD_total(:,2),OH_DD_total(:,1),'or');
hold on;
scatter(OH_DD_total(:,4),OH_DD_total(:,1),'xb');
hold on;
axis square;
grid on;
xlabel('Deadline Delay (s)');
ylabel('Referece ratio (Seq#/Time)');
legend('Red is 100% miss','Blue is 0% miss');
title('Scatter figure of reference ratio verous deadline delay');
saveas(21,'Scatter figure of reference ratio verous deadline delay.fig');

disp(' ')
disp('#########################################################')
disp(' ')
disp('Overhead_Deadline_delay_Program has been successfully completed')
disp(' ')
disp('#########################################################')

