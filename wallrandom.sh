#!/bin/bash

##

dir=$HOME/bin #your scripts dir
picURL=https://alpha.wallhaven.cc/wallpapers/full


##Wallhaven setings
site=https://alpha.wallhaven.cc

sorting=toplist #Relevance / Random / Date Added / Views / Favorites / Toplist
purity=100 
categories=011 # 100 - General / 110 General + Anime / 111 ALL / 011 Anime + People / 010 - Anime / 001 - People / 111 - People + General
attleast=1920x1080 # your resolution
topRange=6M # sort by date 1d / 3d / 1w / 1M / 3M / 6M / 12M / 1y
random=$(shuf -i1-20 -n1) # specify the desired number of pages. Сhane this -i1-20

siteURL="$site/search?q=&categories=$categories&purity=$purity&atleast=$atleast&topRange=$topRange&sorting=$sorting&order=desc&page=$random"

# time flag

while getopts ":d:rt:" o; do 
  case $o in
    t) time=$OPTARG;;
  esac
done

##

while true ; do


html=$(curl -s "$siteURL" | grep -o '<a class="preview" href="https://alpha.wallhaven.cc/wallpaper/[0-9]*"' | sed  's .\{24\}  ' | tr -d '"' | awk 'BEGIN { srand() }
{ l[NR]=$0 } END { print l[int(rand() * NR + 1)] }'  )

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
	sleep $time
  
done

exit
