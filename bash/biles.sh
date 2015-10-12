#!/bin/bash
for files in $(echo *.txt)
do
mkdir -p  /Users/yu/Documents/MATLAB/BL/BL_Program/bash/13$$/${files%.*}
mv ${files} /Users/yu/Documents/MATLAB/BL/BL_Program/bash/13$$/${files%.*}
done