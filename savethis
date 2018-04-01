#!/bin/bash

red="$(tput setaf 1)"
green="$(tput setaf 14)"
blue="$(tput setaf 4)"
nc="$(tput sgr0)"
dir=$HOME/bin #your script dir
pic=$(head -1 $dir/wall.txt)
folder=$HOME/Pictures/wallhaven #your wallpapers dir

if [ $(find $folder -iname $pic -print) ]  
   then 
   echo "$blue$pic$nc$red already save$nc"
   else
   cp $dir/$pic $folder/$pic 
   echo "$blue$pic$nc$green saved to$nc$blue file://$folder/$pic $nc"
   fi

exit 0 
