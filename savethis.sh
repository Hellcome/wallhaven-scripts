#!/bin/bash

dir=$HOME/bin #your script dir
pic=$(head -1 $dir/wall.txt)
folder=$HOME/Pictures/wallhaven #your wallpapers dir

cp $dir/$pic $folder/$pic

echo saved :3 
