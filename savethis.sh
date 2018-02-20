#!/bin/bash

RED="tput setaf 1"
GREEN="tput setaf 14"
dir=$HOME/bin #your script dir
pic=$(head -1 $dir/wall.txt)
folder=$HOME/Pictures/wallhaven #your wallpapers dir

if [ $(find $folder -iname $pic -print) ]  
   then $RED ; echo "$pic already save"
   else
   cp $dir/$pic $folder/$pic 
   $GREEN ; echo "$pic saved to $folder/$pic"
fi

exit 0 
