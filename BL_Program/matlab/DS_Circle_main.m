close all
clear all
clc

% Read the list file
dirID = fopen('/home/mina/Desktop2/yu/data/list_of_dir.txt');
dir_list_name = textscan(dirID,'%s');
dir_list = dir_list_name{1};
fclose(dirID);

for dir_count = 1 : 1 : length(dir_list)
    dir_name = dir_list{dir_count};
    
    
    % Read the list file
    fileID = fopen(dir_name);
    file_list_name = textscan(fileID,'%s');
    file_list = file_list_name{1};
    fclose(fileID);

    Du_Sum_total = [];

    for file_count = 1 : 1 : length(file_list)
        xpl_file_name = file_list{file_count};
        Du_Sum = Duration_SumOOO(xpl_file_name);
        save([file_list{file_count} '_Duration_Sum'], '-mat','Du_Sum');
        if ~isempty(Du_Sum)
            Du_Sum_total = [Du_Sum_total;Du_Sum];
        end
        disp('---------------------------------------------');
        fprintf('No.%d (%s) has been completed.\n',file_count,xpl_file_name);
        disp('---------------------------------------------');
    end
    save([dir_name '_Duration_SumOOO'],'-mat','Du_Sum_total');

end

disp(' ')
disp('#########################################################')
disp(' ')
disp('Program has been successfully completed')
disp(' ')
disp('#########################################################')
