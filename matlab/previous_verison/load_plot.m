clear all
clc

%% usd for Overhead_delay program
x = importdata ('/home/mina/Desktop2/yu/results/Overhead_delay/cellular/indoor-slow-unlimited/OH_DD_total.mat');
y = importdata ('/home/mina/Desktop2/yu/results/Overhead_delay/cellular/outdoor-fast-unlimited/OH_DD_total.mat');

OH_DD_total = [x;y];
save('/home/mina/Desktop2/yu/BL/BL_Program/matlab/OH_DD_total.mat','OH_DD_total');
        
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

%% usd for Total_OOO_verous_Total_durtion program
% x = importdata ('/home/mina/Desktop2/yu/results/Total_OOO_verous_Total_durtion/cellular/indoor-slow-unlimited/Duration_SumOOO.mat');
% y = importdata ('/home/mina/Desktop2/yu/results/Total_OOO_verous_Total_durtion/cellular/outdoor-fast-unlimited/Duration_SumOOO.mat');
% 
% Du_Sum_total = [x;y];
% save('/home/mina/Desktop2/yu/BL/BL_Program/matlab/Duration_SumOOO.mat','Du_Sum_total');
