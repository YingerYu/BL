clc
clear


for fig = [4:7 9]
    figure(fig)
    clf
end

box_scen_cntr = 0;
box_data      = [];
box_group     = [];
rec = [];
legendStr = [];


for scenarioInx = [1:4 6:7]
    for subScenInx = [0 1 2]
        switch scenarioInx
            case 1
                load('/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/cellular/unlimited/Downlink/OOO_results.mat')
                scenarioTag = 'MC DL regular'; % unlimited
                myLine = 'r-';
                DL_UL = 'DL';

                switch subScenInx
                    case 0
                    % no changes     
                    case 1
                    continue
%                     Scenario = Scenario(1:10);  
%                     myLine = 'r-^';
%                     scenarioTag = [scenarioTag ' [outdoor]'];
                    case 2
                    continue
%                     Scenario = Scenario(11:14);  
%                     myLine = 'r-v';
%                     scenarioTag = [scenarioTag ' [indoor]'];
                    otherwise
                    error('INVALID sub-SCENARIO !!!')
                end

                disp(scenarioTag)

                for i = 1 : length(Scenario), 
%                     disp([num2str(i) ' ' Scenario(i).xpl_name{1}]);
                end



            case 2
                load('/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/cellular/80kbps/Downlink/OOO_results.mat')
                scenarioTag = 'MC DL congested'; % 80 kbps
                myLine = 'r--';
                DL_UL = 'DL';
                
                switch subScenInx
                    case 0
                    Scenario = Scenario([1:8, 11:end]); % remove Murray Hill tests
                    case 1
                    continue
                    case 2
                    continue
                    otherwise
                    error('INVALID sub-SCENARIO !!!')
                end

                disp(scenarioTag)

                for i = 1 : length(Scenario), 
%                     disp([num2str(i) ' ' Scenario(i).xpl_name{1}]);
                end


            
            case 3
                load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_2UE_static/Downlink/OOO_results.mat'])            
                scenarioTag = 'SC DL'; % 2 UE static
                myLine = 'b-';
                DL_UL = 'DL';
                
                switch subScenInx
                    case 0
                    continue
                    case 1
                    Scenario = Scenario(1:26);  
                    myLine = 'b-'; % ^';
                    scenarioTag = [scenarioTag ' static'];
                    case 2
                    continue
%                     Scenario = Scenario(27:end);
%                     myLine = 'b-v';
%                     scenarioTag = [scenarioTag ' handovers'];
                    otherwise
                    error('INVALID sub-SCENARIO !!!')
                    crash
                end

                % >>>>>>>>>>>>>>>>>>>>>
                % add data from "1 UE static" - case 5
                aux_Scenario = Scenario;
                load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_1UE_static/Downlink/OOO_results.mat'])                
                Scenario = [aux_Scenario, Scenario];
                % <<<<<<<<<<<<<<<<<<<<<
                
                disp(scenarioTag)

                for i = 1 : length(Scenario), 
%                     disp([num2str(i) ' ' Scenario(i).xpl_name{1}]);
                end

            
            
            case 4
                load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_1UE_handover/Downlink/OOO_results.mat'])
                scenarioTag = 'SC DL handovers [1 UE]'; % 1 UE handover
                myLine = 'b--';
                DL_UL = 'DL';

                switch subScenInx
                    case 0
                    % no changes
                    case 1
                    continue
%                     Scenario = Scenario(1:8);   
%                     myLine = 'b--^';
%                     scenarioTag = [scenarioTag ' [long HO]'];
                    case 2
                    continue
%                     Scenario = Scenario(9:15); 
%                     myLine = 'b--v';
%                     scenarioTag = [scenarioTag ' [short HO]'];
                    otherwise
                    error('INVALID sub-SCENARIO !!!')
                    crash
                end

                % >>>>>>>>>>>>>>>>>>>>>
                % add HOs from "2 UE static" - case 3
                aux_Scenario = Scenario;
                load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_2UE_static/Downlink/OOO_results.mat'])            
                Scenario = [aux_Scenario, Scenario(27:end)];
                scenarioTag = 'SC DL handovers'; % 1 UE HOs + 2 UE HOs
                % <<<<<<<<<<<<<<<<<<<<<

                disp(scenarioTag)

                for i = 1 : length(Scenario), 
%                     disp([num2str(i) ' ' Scenario(i).xpl_name{1}]);
                end
            
            
            
%             case 5
%                 DL_UL = 'DL';
%                 load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_1UE_static/Downlink/OOO_results.mat'])
%                 scenarioTag = 'SC DL static [1 UE]'; % 1 UE static 
%                 myLine = 'm-';
% 
%                 switch subScenInx
%                     case 0
%                     % no changes
%                     case 1
%                     continue
%                     case 2
%                     continue
%                     otherwise
%                     error('INVALID sub-SCENARIO !!!')
%                     crash
%                 end
% 
%                 disp(scenarioTag)
% 
%                 for i = 1 : length(Scenario), 
% %                     disp([num2str(i) ' ' Scenario(i).xpl_name{1}]);
%                 end
            
            
            
            case 6
                load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_2UE_static/Uplink/OOO_results.mat'])
                scenarioTag = 'SC UL static'; % 2 UE static
                myLine = 'm-';
                DL_UL = 'UL';

                switch subScenInx
                    case 0
                    % no changes
                    case 1
                    continue
                    case 2
                    continue
                    otherwise
                    error('INVALID sub-SCENARIO !!!')
                    crash
                end

                % >>>>>>>>>>>>>>>>>>>>>
                % add data from "1 UE static" - case 5
                aux_Scenario = Scenario;
                load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_1UE_static/Uplink/OOO_results.mat'])                
                Scenario = [aux_Scenario, Scenario];
                % <<<<<<<<<<<<<<<<<<<<<

                disp(scenarioTag)

                for i = 1 : length(Scenario), 
%                     disp([num2str(i) ' ' Scenario(i).xpl_name{1}]);
                end
            
            
            
            case 7
                load(['/home/skucera/Desktop/_TCP_TRACES/Results/Results_v4/small_cell/EBC_1UE_handover/Uplink/OOO_results.mat'])
% >>>>>>>>>>>>  scenarioTag = 'SC UL handovers [1 UE]'; % 1 UE handover
                scenarioTag = 'SC UL handovers';        % 1 UE handover
                myLine = 'm--';
                DL_UL = 'UL';

                switch subScenInx
                    case 0
                    % no changes ... short HOs only
                    case 1
                    continue
                    case 2
                    continue
                    otherwise
                    error('INVALID sub-SCENARIO !!!')
                    crash
                end

                disp(scenarioTag)

                for i = 1 : length(Scenario), 
%                     disp([num2str(i) ' ' Scenario(i).xpl_name{1}]);
                end
            
            
            
            otherwise
                error('INVALID SCENARIO !!!')
        end

        e_s_MB = [];
        E_s_MB = [];
        
        r_kbps = [];
        d_s    = [];
        BS_kB  = [];


        for scen_inx = 1 : length(Scenario)
            for xpl_inx = 1 : length(Scenario(scen_inx).([DL_UL '_session']))
                if ~isempty(Scenario(scen_inx).([DL_UL '_session']){xpl_inx})

                    if sum(abs(diff([...
                       length([Scenario(scen_inx).([DL_UL '_session']){xpl_inx}.R_Ratio]), 
                       length([Scenario(scen_inx).([DL_UL '_session']){xpl_inx}.D_NO_FEC]),
                       length([Scenario(scen_inx).([DL_UL '_session']){xpl_inx}.BS_NO_FEC])
                       ])))
                        continue % crash
                    end

                    % data preparation
                    resol_s_B = [0.1   0.1e6];

                    duration_sec_B =            Scenario(scen_inx).Duration_Length{xpl_inx}        ;
                    aux            = vertcat(   Scenario(scen_inx).([DL_UL '_session']){xpl_inx}.OOO_area   );
                    aux_e_s_B      = [aux(:,1)-aux(1,1),  (aux(:,2)-aux(1,2))];

                    aux_r_kbps  = [Scenario(scen_inx).([DL_UL '_session']){xpl_inx}.R_Ratio    ]'    * 8 / 1000;  % B / s
                    aux_d_s     = [Scenario(scen_inx).([DL_UL '_session']){xpl_inx}.D_NO_FEC   ]'              ;  % s
                    aux_BS_kB   = [Scenario(scen_inx).([DL_UL '_session']){xpl_inx}.BS_NO_FEC  ]' * 1388 / 1000;  % pkt / s
                    
                    
                    % filter valid data
                    valid_inx = find(aux_d_s > 1e-3); % min delay 1 ms !!!!!!!!!!!!!!!!!!!!!!
                    
                    if length(valid_inx) ~= length(aux_d_s)
                        aux_e_s_B  = aux_e_s_B( valid_inx,:);
                        aux_r_kbps = aux_r_kbps(valid_inx  );
                        aux_d_s    = aux_d_s(   valid_inx  );
                        aux_BS_kB  = aux_BS_kB( valid_inx  );
                    end                    

                    
                    % event frequency
                    for c = 1 : 2
                        [h, b] = hist(aux_e_s_B(:,c), ...
                            resol_s_B(c) * [0 : ceil(aux_e_s_B(end,c)/resol_s_B(c))] ...
                            );
                        if c == 1
                            aux2_e_s_MB(:,c) =       sum(h>0) / duration_sec_B(c);
                        else
                            aux2_e_s_MB(:,c) = 1e6 * sum(h>0) / duration_sec_B(c);
                        end
                    end
               
                    % record
                    r_kbps = [r_kbps; aux_r_kbps ];  
                    d_s    = [d_s;    aux_d_s    ];  
                    BS_kB  = [BS_kB;  aux_BS_kB  ];  
                    e_s_MB = [e_s_MB; aux2_e_s_MB];  
                end
            end % xpl
        end % scen

        
        disp(['   inter-event period [s] = ' num2str(round(1./mean(   e_s_MB(:,1))))])
        
        
        bin_r = [1e1:1e1:9e1, 1e2:1e2:9e2, 1e3:1e3:9e3, 1e4:1e4:1e5]; 
        bin_d = [1e-2:1e-2:9e-2, 1e-1:1e-1:9e-1 1e0:1e0:1e1]; 
        bin_B = [1:9, 10:10:100]; % 0.1:0.1:0.9,  , 100:100:1e3

        [h_d_r   ,  ~] = hist3([d_s     r_kbps], {bin_d, bin_r});
        [h_BS_r  ,  ~] = hist3([BS_kB   r_kbps], {bin_B, bin_r});
        [h_d_BS  ,  ~] = hist3([d_s     BS_kB ], {bin_d, bin_B}); 

        

        %% 
        viewAngle = [0 90]; % pcolor
        % viewAngle = [45 45]; 

%         figure(1)
%         subplot(4, 3, 1 + 3*(scenarioInx-1) + subScenInx)
%         plotData = h_d_r / sum(sum(h_d_r));
%         % plotData(plotData == 0) = NaN;
%         surf(bin_r, bin_d, plotData);
%             set(gca, 'Xscale', 'log', 'Yscale', 'log')
%             xlabel('payload data rate [kbps]')
%             ylabel('re-ordering delay [s]')
%             title(scenarioTag)
%             view(viewAngle)
%             colorbar
% 
%         figure(2)
%         subplot(4, 3, 1 + 3*(scenarioInx-1) + subScenInx)
%         plotData = h_BS_r / sum(sum(h_BS_r));
%         % plotData(plotData == 0) = NaN;
%         surf(bin_r, bin_B, plotData);
%             set(gca, 'Xscale', 'log', 'Yscale', 'log')
%             xlabel('payload data rate [kbps]')
%             ylabel('re-ordered block size [kB]')
%             title(scenarioTag)
%             view(viewAngle)
%             colorbar
% 
%         figure(3)
%         subplot(4, 3, 1 + 3*(scenarioInx-1) + subScenInx)
%         plotData = h_d_BS / sum(sum(h_d_BS));
%         % plotData(plotData == 0) = NaN;
%         surf(bin_B, bin_d, plotData);
%             set(gca, 'Xscale', 'log', 'Yscale', 'log')
%             xlabel('re-ordered block size [kB]')
%             ylabel('re-ordering delay [s]')
%             title(scenarioTag)
%             view(viewAngle)
%             colorbar


            
        %%
        legendStr{end+1} = scenarioTag;

        figure(4)
        dim = 2;
        hold on
        plot(bin_d, cumsum(  sum(h_d_r   , dim)  ) / sum(sum(h_d_r   )), myLine, 'LineWidth', 2);
        hold off
            h_a4 = gca;
            set(gca, 'Xscale', 'log')
            xlabel('re-ordering delay [s]')
            ylabel('PDF')
            axis([min(bin_d) max(bin_d) 0 1])
            h_leg4 = legend(legendStr, 'Location', 'SouthEast');

        if scenarioInx ~= 4 && scenarioInx ~= 7
            myStr = [num2str(round(1./mean(   e_s_MB(:,1)))) 's'];
            level = 0.8;
        else
            myStr = 'N/A';
            level = 0.7;
            
            if scenarioInx == 4 
            text(12e-3, 0.9, 'Average')
            text(12e-3, 0.8, 'inter-event')
            text(12e-3, 0.7, 'period:')
            end
        end
        
        switch scenarioInx
            case  1
                myStrColor = [1 0 0];
                myHorAlign = 'center';
            case  2
                myStrColor = [1 0 0];
                myHorAlign = 'right';
            case  3
                myStrColor = [0 0 1];
                myHorAlign = 'center';
            case  4
                myStrColor = [0 0 0];
                myHorAlign = 'right';
            case  6
                myStrColor = [1 0 1];
                myHorAlign = 'center';
            case  7
                myStrColor = [0 0 0];
                myHorAlign = 'right';
            case  5
                myStrColor = [0 1 0];
                myHorAlign = 'center';
            otherwise
                error('Wrong scenario!')
        end
        
        inx = find(abs(cumsum(  sum(h_d_r   , dim)  ) / sum(sum(h_d_r   ))-level) == min(abs(cumsum(  sum(h_d_r   , dim)  ) / sum(sum(h_d_r   ))-level)));
        text(bin_d(inx(1)), level, myStr, 'Color', myStrColor, 'BackgroundColor', [1 1 1], 'HorizontalAlignment', myHorAlign)

        
        figure(5)
        dim = 2;
        hold on
        plot(bin_B, cumsum(  sum(h_BS_r  , dim)  ) / sum(sum(h_BS_r  )), myLine, 'LineWidth', 2);
        hold off
            h_a5 = gca;
            set(gca, 'Xscale', 'log')
            xlabel('re-ordered block size [kB]')
            ylabel('PDF')
            axis([min(bin_B) max(bin_B) 0 1])
            h_leg5 = legend(legendStr, 'Location', 'SouthEast');

            
        figure(6)
        dim = 1;
        hold on
        plot(bin_r, cumsum(  sum(h_BS_r, dim)  ) / sum(sum(h_BS_r)), myLine, 'LineWidth', 2);
        
%         if scenarioInx ~= 4 && scenarioInx ~= 7
%             myStr = [num2str(round(1./mean(   e_s_MB(:,1))))];
%             level = 0.9;
%         else
%             myStr = 'N/A';
%             level = 0.8;
%             
%             if scenarioInx == 4 
%             text(13, 0.9, 'Avg. inter-event')
%             text(13, 0.8, 'period [seconds]:')
%             end
%         end
%         
%         switch scenarioInx
%             case {1,2}
%                 myStrColor = [1 0 0];
%             case {3,4}
%                 myStrColor = [0 0 1];
%             case {6,7}
%                 myStrColor = [1 0 1];
%             case  5
%                 myStrColor = [0 1 0];
%             otherwise
%                 error('Wrong scenario!')
%         end
%         
%         inx = find(abs(cumsum(  sum(h_BS_r, dim)  ) / sum(sum(h_BS_r))-level) == min(abs(cumsum(  sum(h_BS_r, dim)  ) / sum(sum(h_BS_r))-level)));
%         text(bin_r(inx), level, myStr, 'Color', myStrColor, 'BackgroundColor', [1 1 1], 'HorizontalAlignment', 'center')

        hold off
            h_a6 = gca;
            set(gca, 'Xscale', 'log')
            xlabel('payload data rate [kbps]')
            ylabel('PDF')
            axis([min(bin_r) max(bin_r) 0 1])
            h_leg6 = legend(legendStr, 'Location', 'SouthEast');
        
            
            
        %%
        Dr_w_s_pctl = [];

        ovRT_kbps = [1e0:1e0:9e0, 1e1:1e1:9e1, 1e2:1e2:9e2, 1e3:1e3:9e3, 1e4:1e4:10e4];
        ovHD_pc   = [1:100] / 100;

        
        pctl = [95]; % [5 50 95];

        % ABSOLUTE RATE
        for r_inx = 1 : length(ovRT_kbps)
            Dr_w_s  = 8*BS_kB ./ (ovRT_kbps(r_inx));
            Rdl_Rex = ovRT_kbps(r_inx) ./ r_kbps;

            Dr_w_s_pctl(  :,r_inx) =  prctile(Dr_w_s , pctl);
            Rdl_geq_Rex_pc( r_inx) =  sum(Rdl_Rex <= 1) / length(Rdl_Rex);
        end

        % RELATIVE OVERHEAD
        for o_inx = 1 : length(ovHD_pc)
            Do_w_s  = 8*BS_kB ./ (ovHD_pc(o_inx)*r_kbps);

            Do_w_s_pctl(  :,o_inx) =  prctile(Do_w_s , pctl);
        end

        % BOX
        pctl_vect = [1 33 66 100];

        box_scen_cntr = box_scen_cntr + 1;
        box_pctl_cntr = 1;
        for o_inx = pctl_vect
%             Do_w_s  = 8*BS_kB ./ (ovHD_pc(o_inx)*r_kbps);
            Do_w_s  = min(d_s, 8*BS_kB ./ (ovHD_pc(o_inx)*r_kbps));

            box_data    = [box_data;                        Do_w_s  ];
            box_group   = [box_group; (4*(box_scen_cntr-1)+box_pctl_cntr) * ones(size(Do_w_s))];
            
            box_pctl_cntr = box_pctl_cntr + 1;
        end

%         figure(7)
%         hold on
%         plot(ovHD_pc,  Do_w_s_pctl, myLine, 'LineWidth', 2);
%         hold off
%             h_a7 = gca;
%             set(gca, 'Xscale', 'log', 'Yscale', 'log')
%             xlabel('relative FPLP overhead [%]')
%             ylabel([num2str(pctl) '-th %-tile re-ordering delay [s]'])
%             axis([0.01 1 0.01 100])
%             h_leg7 = legend(legendStr, 'Location', 'NorthEast');

%         figure(8)
%             h_a8 = gca;
%         hold on
%         plot(ovRT_kbps,  Dr_w_s_pctl, myLine, 'LineWidth', 2);
%         hold off
%             set(gca, 'Xscale', 'log', 'Yscale', 'log')
%             xlabel('absolute FPLP data rate [kbps]')
%             ylabel([num2str(pctl) '-th %-tile re-ordering delay [s]'])
%             axis([min(ovRT_kbps) max(ovRT_kbps) 0.01 100])
%             h_leg8 = legend(legendStr, 'Location', 'NorthEast');
            
        figure(9)
        hold on
        plot(ovRT_kbps, Rdl_geq_Rex_pc, myLine, 'LineWidth', 2);
        hold off
            h_a9 = gca;
            set(gca, 'Xscale', 'log', 'Yscale', 'lin')
            xlabel('absolute FPLP data rate [kbps]')
            ylabel('$\Pi(R_{FPLP} \leq R_{payload})$', 'interpreter', 'Latex')
            axis([min(ovRT_kbps) max(ovRT_kbps) 0 1])
            h_leg9 = legend(legendStr, 'Location', 'SouthWest');
    end % subScen
end % scenario


figure(7)
dist_offset = [0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 7 7 7 7 8 8 8 8 9 9 9 9];
myColors = [1 0 0; 1 0 0; 1 0 0; 1 0 0; 
            1 0 0; 1 0 0; 1 0 0; 1 0 0; 
            0 0 1; 0 0 1; 0 0 1; 0 0 1; 
            0 0 1; 0 0 1; 0 0 1; 0 0 1; 
            1 0 1; 1 0 1; 1 0 1; 1 0 1;
            1 0 1; 1 0 1; 1 0 1; 1 0 1;
            1 0 0; 1 0 0; 1 0 0; 1 0 0; 
            1 0 0; 1 0 0; 1 0 0; 1 0 0; 
            0 0 1; 0 0 1; 0 0 1; 0 0 1; 
            0 0 1; 0 0 1; 0 0 1; 0 0 1; 
            0 1 0; 0 1 0; 0 1 0; 0 1 0;
            0 1 0; 0 1 0; 0 1 0; 0 1 0 ];

N_scen = length(unique(box_group)) / 4;

x_ticks  = [1:(4*N_scen)] + dist_offset(1:(4*N_scen));
myColors = myColors(1:4*N_scen, :);
myLabels = repmat({'', '', '', ''}, 1, N_scen);

hold on
plot(0:5*N_scen, 0.1*ones(1,5*N_scen+1), 'k')
plot([20 20], [1e-4 1e2], 'k:')
boxplot(box_data, box_group, 'positions', x_ticks, 'colors', myColors, 'labels', myLabels, 'whisker', 10000)
hold off

h_a7 = gca;
set(gca, 'Xscale', 'lin', 'Yscale', 'log')
ylabel('re-ordering delay [s]')
axis([0 5*N_scen 1e-4 1e2])

if pctl_vect(1) == 1
    text(0.6, 3.5e-4, [num2str(          0 ) ' ' num2str(pctl_vect(2)) ' ' num2str(pctl_vect(3)) ' ' num2str(pctl_vect(4)) '\%'], 'FontSize', 8)
else
    text(0.6, 3.5e-4, [num2str(pctl_vect(1)) ' ' num2str(pctl_vect(2)) ' ' num2str(pctl_vect(3)) ' ' num2str(pctl_vect(4)) '\%'], 'FontSize', 8)
end

text(0.6, 1.5e-4, ['overhead'], 'FontSize', 8)
text(19, 3.5e1, 'downlink', 'HorizontalAlignment', 'right')
text(21, 3.5e1, 'uplink', 'HorizontalAlignment', 'left')

for xti = 1 : 2 : length(legendStr)
    text(x_ticks(4*(xti-1)+1)+1.5, 4e-5,  legendStr{xti}([1:3,7:end]) , 'HorizontalAlignment', 'center')
end
for xti = 2 : 2 : length(legendStr)
    text(x_ticks(4*(xti-1)+1)+1.5, 1e-5,  legendStr{xti}([1:3,7:end]) , 'HorizontalAlignment', 'center')
end

    
% figure(8)
%     hold on
%     plot(ovRT_kbps, 0.1*ones(size(ovRT_kbps)), 'k-', 'LineWidth', 1);
%     hold off


%% export

myExport = 1;

figure(4)
    myFigFor = figFor('YXaspectRatio', 0.5, 'marginYbottom_cm', 1.5);
    myLegFor = legFor(gca, h_leg4, 'legendLineScale', 0.6, 'legendTextScale', 1.6);
    fef(gcf, myExport,  ['/home/skucera/Desktop/ICC_2016/used_figs/PDF_delay'], myFigFor, NaN, myLegFor)
    box on  

figure(5)
    myFigFor = figFor('YXaspectRatio', 0.5, 'marginYbottom_cm', 1.5);
    myLegFor = legFor(gca, h_leg5, 'legendLineScale', 0.6, 'legendTextScale', 1.6);
    fef(gcf, myExport,  ['/home/skucera/Desktop/ICC_2016/used_figs/PDF_block_size'], myFigFor, NaN, myLegFor)
    box on  

figure(6)
    myFigFor = figFor('YXaspectRatio', 0.5, 'marginYbottom_cm', 1.5);
    myLegFor = legFor(gca, h_leg6, 'legendLineScale', 0.6, 'legendTextScale', 1.6);
    fef(gcf, myExport,  ['/home/skucera/Desktop/ICC_2016/used_figs/PDF_data_rate'], myFigFor, NaN, myLegFor)
    box on  

figure(9)
    myFigFor = figFor('YXaspectRatio', 0.5, 'marginYbottom_cm', 2, 'marginYtop_cm', 0.8);
    myLegFor = legFor(gca, h_leg9, 'legendLineScale', 0.6, 'legendTextScale', 1.6);
    fef(gcf, myExport,  ['/home/skucera/Desktop/ICC_2016/used_figs/overhead_excess_probability'], myFigFor, NaN, myLegFor)
    box on  

figure(7)
    myFigFor = figFor('YXaspectRatio', 0.5, 'marginYbottom_cm', 2, 'marginYtop_cm', 0.8, 'marginXright_cm', 0.9, 'marginXleft_cm', 2);
    fef(gcf, myExport,  ['/home/skucera/Desktop/ICC_2016/used_figs/performance_relative_overhead'], myFigFor, NaN, [])
    box on  



