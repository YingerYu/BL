% function main()
close all
clear all
clc

% Read the list file
fileID = fopen('/home/mina/Desktop2/yu/BL/BL_Program/matlab/list.txt');
file_list_name = textscan(fileID,'%s');
file_list = file_list_name{1};
fclose(fileID);

for file_count = 1 : 1 : length(file_list)
    fprintf('%s\n',file_list{file_count});
    xpl_file_name = file_list{file_count};
    fid1 = fopen(xpl_file_name);
    b = textscan(fid1,'%s');
    output_name = [xpl_file_name,'_OOO_DATA_Output.txt'];
    save(output_name);
%     fid2 = fopen('%d_OOO_DATA_Output.txt', 'w', 'n', 'utf-8');
    fid2 = fopen(output_name, 'w', 'n', 'utf-8');
    fprintf(fid2,'I am so handsome!');
end

% end