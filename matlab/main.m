close all
clear all
clc

% Read the list file
dirID = fopen('/home/mina/Desktop2/test/list_of_dir_dl.txt');
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
    delay_bin = 0.001 : 0.005 : 5;
    block_size_bin = 1 : 1 : 10;
    count = 0;
    %
    CDF_TCP_RX_JITTER_sum = zeros(size(length(delay_bin)));
    CDF_TCP_TX_JITTER_sum = zeros(size(length(delay_bin)));
    CDF_sum               = zeros(size(length(delay_bin)));
    OOO_DATA_calculated_total = [];
    %
    OH_DD_total = [];
    %
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
            count = count+1;
            % OOO_data function
            OOO_output = OOO_data(xpl_file_name);
            CDF_TCP_RX_JITTER_sum = CDF_TCP_RX_JITTER_sum + OOO_output{1}; 
            CDF_TCP_TX_JITTER_sum = CDF_TCP_TX_JITTER_sum + OOO_output{2}; 
            CDF_sum = CDF_sum + OOO_output{3}; 
            OOO_DATA_calculated_total = [OOO_DATA_calculated_total;OOO_output{4}];
            
            % Overhead function
            OH_DD = Overhead_delay(xpl_file_name);
            save([file_list{file_count} '_OH_DD'], '-mat','OH_DD');
            if ~isempty(OH_DD)
                OH_DD_total = [OH_DD_total;OH_DD];
            end
            
            % duration_sum function
            xpl_index = xpl_index+1;   
            Du_Sum = Duration_SumOOO(xpl_file_name);
            if ~isempty(Du_Sum)
                REC(scenario_index).Du_Seq{xpl_index} = Du_Sum{1};        
                REC(scenario_index).DATA{xpl_index} = Du_Sum{2};
            end
            
            disp('---------------------------------------------');
            fprintf('[ %d/%d ] No.%d (%s) has been completed.\n',file_count, length(file_list), count, xpl_file_name);
            disp('---------------------------------------------');
        end
    end
    %
    CDF_TCP_RX_JITTER_average = CDF_TCP_RX_JITTER_sum/count;
    CDF_TCP_TX_JITTER_average = CDF_TCP_TX_JITTER_sum/count;
    CDF_average = CDF_sum/count;    
    save([dir_name '_OOO_data_calculated.mat'],'OOO_DATA_calculated_total');
    save([dir_name '_CDF_TCP_RX_JITTER_average.mat'],'CDF_TCP_RX_JITTER_average');
    save([dir_name '_CDF_TCP_TX_JITTER_average.mat'],'CDF_TCP_TX_JITTER_average');
    save([dir_name '_CDF_average.mat'],'CDF_average');
    %
    save([dir_name '_OH_DD.mat'],'-mat','OH_DD_total');
    %
    save([dir_name '_REC_OOO_area.mat'],'REC');
    
    % figure1 is the CDF_TCP_RX_JITTER
    figure(1);
    semilogx(delay_bin, CDF_TCP_RX_JITTER_average,'-g');
    hold on;
    axis square;
    grid on;
    xlabel('Delta\_T\_of\_TCP\_RX\_DATA (seconds)');
    ylabel('CDF');
    title('CDF of TCP\_RX\_JITTER');
    saveas(1,[dir_name '_Average_CDF_of_TCP_RX_JITTER']);

    % figure2 is the CDF_TCP_TX_JITTER
    figure(2);
    semilogx(delay_bin, CDF_TCP_TX_JITTER_average,'-b');
    hold on;
    axis square;
    grid on;
    xlabel('Delta\_T\_of\_TCP\_TX\_DATA (seconds)');
    ylabel('CDF');
    title('CDF of TCP\_TX\_JITTER');
    saveas(2,[dir_name '_Average_CDF_of_TCP_TX_JITTER']);


    % figure3 is the CDF_average
    figure(3);
    semilogx(delay_bin, CDF_average,'-m');
    hold on;
    axis square;
    grid on;
    xlabel('Delay (seconds)');
    ylabel('CDF');
    title('CDF of (TCP\_RX\_time - TCP\_TX\_time)');
    saveas(3,[dir_name '_Average_CDF_of_(TCP_RX_time_minus_TCP_TX_time)']);

    % figure4 is the Unusual numbers of packets VS dalay
    figure(4);
    x = OOO_DATA_calculated_total(:,1);
    y = OOO_DATA_calculated_total(:,2);
    plot(x,y,'or');
    hold on;
    axis square;
    % axis([0 5 0 10]);
    grid on;
    xlabel('Out\_of\_order dalay (seconds)');
    ylabel('Out\_of\_order block numbers (1388bytes per block)');
    title('OOO block numbers VS OOO dalay');
    saveas(4,[dir_name '_Total_OOO_block_numbers_VS_OOO_dalay']);

    %  figure5 is the pkt_block VS HIST
    figure(5);
    hist(OOO_DATA_calculated_total(:,1),delay_bin);
    axis([-0.5 5 0 inf]);
    xlabel('Delay bins');
    ylabel('Hist');
    saveas(5,[dir_name '_Hist_VS_Delay_bins']);

    %  figure6 is the dalay_bins VS HIST
    figure(6);
    hist(OOO_DATA_calculated_total(:,2),block_size_bin);
    axis([0 10 0 inf]);
    xlabel('Block size');
    ylabel('Hist');
    saveas(6,[dir_name '_Hist_VS_Block_size']);

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
    saveas(21,[dir_name '_Scatter figure of reference ratio verous deadline delay.fig']);

end


disp(' ')
disp('#########################################################')
disp(' ')
disp('Program has been successfully completed')
disp(' ')
disp('#########################################################')
