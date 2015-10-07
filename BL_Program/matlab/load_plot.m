clear all
clc
x = importdata ('/home/mina/Desktop2/yu/results/Overhead_delay/cellular/indoor-slow-unlimited/OH_DD_total.mat');
y = importdata ('/home/mina/Desktop2/yu/results/Overhead_delay/cellular/outdoor-fast-unlimited/OH_DD_total.mat');

z = [x;y];
save('/home/mina/Desktop2/yu/BL/BL_Program/matlab/OH_DD_total.mat','z');
        
% figure21 is the scatter figure of reference ratio verous deadline delay
figure(21);
scatter(z(:,2),z(:,1),'or');
hold on;
scatter(z(:,4),z(:,1),'xb');
hold on;
axis square;
grid on;
xlabel('Deadline Delay (s)');
ylabel('Referece ratio (Seq#/Time)');
legend('Red is 100% miss','Blue is 0% miss');
title('Scatter figure of reference ratio verous deadline delay');
saveas(21,'Scatter figure of reference ratio verous deadline delay.fig');
