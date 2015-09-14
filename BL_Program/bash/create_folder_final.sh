# create a corresponding folder(without file surfix) for each file in a folder

function create_folder()
{
    # remove filename surfix    
    filename=`echo ${1%%.*}`
    
    # mkdir only if a dir does not already exist
    mkdir -p $filename
    
    mv $1 $filename
}

for entry in /Users/yu/Documents/MATLAB/BL/BL_Program/bash/13/*
do
    if [ -d "$entry" ]; then
        for en in "$entry"/*
        do
            create_folder "$en"
        done
    elif [ -f "$entry" ]; then
        create_folder "$entry"
    fi
done

# [08:33:38][ryu@test]$ pwd
# /Users/ryu/Desktop/test
# [08:33:49][ryu@test]$ tree
# .
# ├── 1.txt
# ├── 2.txt
# └── second
#     └── 3.txt

# 1 directory, 3 files
# [08:33:52][ryu@test]$ cd ..
# [08:33:55][ryu@Desktop]$ source create_folder.sh 
# [08:34:02][ryu@Desktop]$ tree test/
# test/
# ├── 1
# │   └── 1.txt
# ├── 2
# │   └── 2.txt
# └── second
#     └── 3
#         └── 3.txt

# 4 directories, 3 files
