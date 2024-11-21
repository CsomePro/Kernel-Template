#!/bin/sh

if [ $1 = '-b' ] 
then 
    ./pack.sh
fi

cmd.exe /c start "wt.exe" -w 0 sp -d . wsl.exe -d Ubuntu-22.04 bash -c "cd $(pwd) && ./gdb.sh" & $(pwd)/start.sh