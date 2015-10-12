There are three folders contain three kinds of results.

**************************************************************************************************************
OOO_Data_v2
This is the folder display out of order packets verous delays.
--OOO_Data_v2
  --cellular
    --80kbps
    --indoor-slow-80kbps
    --indoor-slow-unlimited
    --outdoor-fast-80kbps-3G
    --outdoor-fast-80kbps-4G
    --outdoor-fast-unlimited
    --outdoor-slow-80kbps
    --unlimited
  --small_cell
    --AIDA
    --EBC_1UE_handover
    --EBC_1UE_static
    --EBC_2UE_static
    --EBC_initial_data
  --wifi
For each sub folder, it contains 6 figures and a mat data. 
For the mat data, there are two column, first is the delay and second is the total number of packets
**************************************************************************************************************


##############################################################################################################
Overhead_delay
This is the folder display Overhead packets verous delays.
--OOO_Data_v2
  --cellular
    --80kbps
    --indoor-slow-80kbps
    --indoor-slow-unlimited
    --outdoor-fast-80kbps-3G
    --outdoor-fast-80kbps-4G
    --outdoor-fast-unlimited
    --outdoor-slow-80kbps
    --unlimited
  --small_cell
    --AIDA
    --EBC_1UE_handover
    --EBC_1UE_static
    --EBC_2UE_static
    --EBC_initial_data
  --wifi
For each sub folder, it contains 1 figures and 1 mat data. 
For the mat data, (each line means each xpl file), there are 5 column, 
1st column, reference rate
2nd column, 100% miss situation, delay
3rd column, 100% miss situation, block size (packets)
4th column, 0% miss situation, delay
5th column, 0% miss situation, block size (packets)
##############################################################################################################


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Total_OOO_verous_Total_durtion
This is the folder display total number of order packets verous total duration time.
--OOO_Data_v2
  --cellular
    --80kbps
    --indoor-slow-80kbps
    --indoor-slow-unlimited
    --outdoor-fast-80kbps-3G
    --outdoor-fast-80kbps-4G
    --outdoor-fast-unlimited
    --outdoor-slow-80kbps
    --unlimited
  --small_cell
    --AIDA
    --EBC_1UE_handover
    --EBC_1UE_static
    --EBC_2UE_static
    --EBC_initial_data
  --wifi
For each sub folder, it contains 1 mat data. 
For the mat data, there are 2 column, 
1st column, the total duration (each line means each xpl file)
2nd column, the total number of out of order packets happened (each line means each xpl file)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



