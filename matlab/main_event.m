close all
clear all
clc

% Read the list file
dirID = fopen('/home/mina/Desktop2/yu/results/list_of_dir_dl.txt');
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

    % Store all the data for each scenario
    scenario_index  = 1;
    xpl_index       = 0;
    Scenario        = [];
    % main loop, call the Duration_SumOOO function
    for file_count = 1 : 1 : length(file_list)
        xpl_file_name = file_list{file_count};
        if (xpl_file_name == '#')
            scenario_index = scenario_index+1;
            xpl_index = 0;
        end
        if (xpl_file_name ~= '#')
            % OOO_Event function
            OOO_EVENT = OOO_Event(xpl_file_name);                        
            xpl_index = xpl_index+1;   
            Scenario(scenario_index).xpl_name = xpl_file_name;        
            Scenario(scenario_index).DL_session{xpl_index} = OOO_EVENT;
%             Scenario(scenario_index).UL_session{xpl_index} = OOO_EVENT;
            
            disp('---------------------------------------------');
            fprintf('[ %d/%d ] No.%d (%s) has been completed.\n',file_count, length(file_list), xpl_index, xpl_file_name);
            disp('---------------------------------------------');
        end
    end
    
    %
    save([dir_name '_OOO_results.mat'],'Scenario');

end


disp(' ')
disp('#########################################################')
disp(' ')
disp('Program has been successfully completed')
disp(' ')
disp('#########################################################')
