function data_split()

% Read the local file to analysis the data
fid1 = fopen(xml_file_name.xml);

% Create a file to save the data
output_name = [xml_file_name,'_Output.txt'];
save(xml_output_name);
fid2 = fopen(xml_output_name, 'w', 'n', 'utf-8'); 

% Set the expr to select useful informations
expr1 = ''; % white arrow's first line begin with "darrow"
expr2 = '\ '; % space

disp('Loading the file and matching the useful data...')
% Set the file line by line

tline = fgets(fid1);
while ischar(tline)
%     disp(tline)
    if ~isempty(tline) % delete the empty lines
        data_split = regexp(tline, expr2, 'split');
        match_value = strcmp(data_split{1},expr1);
        if (match_value == 1)
            TCP_RX_data(end+1,1) = str2num(data_split{2});
            TCP_RX_data(end,2)   = str2num(data_split{3}); 
        end
    end
    tline = fgets(fid1);
end
fclose(fid1);

disp('...useful data has been matched')

disp('Finding the unusual data...')
TCP_RX_data_sort = sortrows(TCP_RX_data,[2 3]);

end