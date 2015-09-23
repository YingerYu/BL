function main()
close all
clear all
clc

a = cell(0, 2);

for acount = 1 : 1 : 10
    a{acount, 1} = acount;    
    a{acount, 2} = 21-acount;
end

list_new = sortrows(a,2);

figure(1);
for fcount = 1 : 1 : length(list_new)
    x = list_new{fcount,1};
    y = list_new{fcount,2};
    plot(x,y,'*r');
    hold on;
    axis square;
end
% % axis([-100 1100 -100 1100]);
grid on;
xlabel('Delta_time (unusual packets dalay in second)');
ylabel('Delta_seq# (unusual packets numbers)');
title('Unusual packets numbers VS dalays');

figure(2);
% hist(cell2mat(list_new));
histogram(cell2mat(list_new(:,1)));

end
