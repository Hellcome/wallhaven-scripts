#!/bin/bash


dir=$HOME/bin #your scripts dir
picURL=https://alpha.wallhaven.cc/wallpapers/full

##Wallhaven setings
site=https://alpha.wallhaven.cc
sorting=favorites
purity=100
categories=011
attleast=1920x1080

# time flag

while getopts ":d:rt:" o; do 
  case $o in
    t) time=$OPTARG;;
  esac
done

##

while true ; do

html=$(curl -s "$site/search?q=&categories=$categories&purity=$purity&atleast=$atleast&sorting=$sorting&order=desc&page=$(shuf -i1-5 -n1)" | grep -o '<a class="preview" href="https://alpha.wallhaven.cc/wallpaper/[0-9]*"' | sed  's .\{24\}  ' | tr -d '"' | awk 'BEGIN { srand() }
{ l[NR]=$0 } END { print l[int(rand() * NR + 1)] }' )


wall=$(curl -s $html | grep -Po '(?<=src=")[^"]*(jpg|png)' | awk 'NR!~/^(1|2)$/' | cut -c 43-)


cd $dir

wget -q "$picURL/$wall"



rm=$(head -1 $HOME/bin/wall.txt)
rm -f $rm
rm -f wall.txt



gsettings set org.gnome.desktop.background picture-uri "file:///$dir/$wall"

echo $wall > wall.txt

## Time functions

	if [[ -z "${time}" ]] ; then #If time is not set, break loop (so the script finishes).
		break
	fi
	if test ${time} -lt 0 ; then #If time is negative (illegal), break loop (so the script finishes).
		echo "ERROR: Time (-t) needs to be set to a positive number (in seconds). EXITING!"
		break
	fi
	sleep $time
  
done
