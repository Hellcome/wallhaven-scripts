#!/bin/bash

##

#Help function
function HELP {
  echo "Command line switches are optional. The following switches are recognized."
  echo "$blue-s$nc -- Sorting options, use$blue favorites | random | date_added | views | toplist | revelance$nc"
  echo "$blue-r$nc -- Range options, use$blue 1d | 3d | 1w | 1M | 3M | 6M | 1y$nc"
  echo "$blue-c$nc -- Categories options, use$blue 100 - General | 110 - General + Anime | 101 - General + People | 111 - ALL  | 011 - Anime + People | 010 - Anime | 001 - People$nc"
  echo "$blue-t$nc -- Time options, use$blue 10 | 10m | 10h$nc"
  echo "$blue-p$nc -- Purity options, use$blue 100 - SWF | 011 - Scetchy | 001 -NSFW (Need login, change lines in Needed for NSFW block)"
  echo "examle$blue ./wallrandom.sh -s toplist -r 1M -c 010 -t 10m -p 100$nc"
  exit 1
}
##

#####################################
###   Needed for NSFW   ###
#####################################
# Enter your Username
USER="Hellcome"
# Enter your password
# if your password contains ' you need to escape it
# replace all ' with '"'"'
PASS="5q4w3e6r"
#####################################
### End needed for NSFW/Favorites ###
#####################################

function login {


   wget -q --referer=https://alpha.wallhaven.cc \
        https://alpha.wallhaven.cc/auth/login
    token="$(grep 'name="_token"' login | sed 's:.*value=::' \
        | sed 's/.\{2\}$//')"
   
    encoded_pass=$(echo -n "$PASS" | od -An -tx1 | tr ' ' % | xargs printf "%s" )
     wget -q --load-cookies=cookies.txt --keep-session-cookies --save-cookies=cookies.txt --referer=https://alpha.wallhaven.cc/auth/login \
        --post-data="_token=$token&username=$USER&password=$encoded_pass" \
        https://alpha.wallhaven.cc/auth/login
} # /login


dir=$HOME/bin #your scripts dir
picURL=https://alpha.wallhaven.cc/wallpapers/full
red="$(tput setaf 1)"
green="$(tput setaf 14)"
blue="$(tput setaf 4)"
nc="$(tput sgr0)"
##Wallhaven setings
site=https://alpha.wallhaven.cc

sorting=toplist #Relevance / Random / Date Added / Views / Favorites / Toplist
purity=100 
categories=111 # 100 - General / 110 - General + Anime / 101 - General + People / 111 - ALL / 011 - Anime + People / 010 - Anime / 001 - People /
attleast=1920x1080 # your resolution
topRange=6M # sort by date 1d / 3d / 1w / 1M / 3M / 6M / 12M / 1y
random=$(shuf -i1-5 -n1) # specify the desired number of pages. Сhane this -i1-5
#siteURL=""


## Flags
while getopts ":t:s:r:c:p:h" o; do 
  case $o in
    t) time=$OPTARG;;
    s) sorting=$OPTARG
        if [ $sorting != favorites ] && [ $sorting != toplist ] && [ $sorting != random ] && [ $sorting != date_added ] && [ $sorting != views ] && [ $sorting != relevance ] ; then
        echo "$red invalid parameter ($sorting)$nc use$blue favorites | random | date_added | views | toplist | revelance$nc" ; exit 0 
        else 
        echo "sorting set to $blue$sorting$nc"
        fi ;;
    r) topRange=$OPTARG
       if [ $topRange != 1d ] && [ $topRange != 3d ] && [ $topRange != 1w ] && [ $topRange != 1M ] && [ $topRange != 3M ] && [ $topRange != 6M ] && [ $topRange != 1y ] ; then
        echo "$red invalid parameter ($topRange)$nc use$blue 1d | 3d | 1w | 1M | 3M | 6M | 1y$nc" ; exit 0 
        else 
        echo "topRange set to $blue$topRange$nc" 
        fi ;;
    c) categories=$OPTARG
        if [ $categories != 100 ] && [ $categories != 110 ] && [ $categories != 101 ] && [ $categories != 111 ] && [ $categories != 011 ] && [ $categories != 010 ] && [ $categories != 001 ] ; then
        echo "$red invalid parameter ($categories)$nc use$blue 100 - General | 110 - General + Anime | 101 - General + People | 111 - ALL | 011 - Anime + People | 010 - Anime | 001 - People$nc" ; exit 0 
        else 
        echo "categotries set to $blue$categories$nc" 
        fi ;;
    p) purity=$OPTARG
        if [ $purity != 001 ] && [ $purity != 100 ] && [ $purity != 010 ] ; then
        echo "$red invalid parameter ($purity)$nc use$blue 100 - SFW | 001 - NSFW | 011 - Scetchy$nc" ; exit 0 
        else 
        echo "purity set to $blue$purity$nc"
        fi ;;
    h)  HELP
        ;;
  esac
done

while true ; do

if  [ "$purity" == 001 ]

then

cd $dir  

login "$USER" "$PASS"

html=$(curl -s --cookie cookies.txt "$site/search?q=&categories=$categories&purity=$purity&atleast=$atleast&topRange=$topRange&sorting=$sorting&order=desc&page=$random" | grep -o '<a class="preview" href="https://alpha.wallhaven.cc/wallpaper/[0-9]*"' | sed  's .\{24\}  ' | tr -d '"' | awk 'BEGIN { srand() }
{ l[NR]=$0 } END { print l[int(rand() * NR + 1)] }' )

wall=$(curl -s --cookie cookies.txt "$html" | grep -Po '(?<=src="//wallpapers.wallhaven.cc/wallpapers/full/)[^"]*(jpg|png|gif|bmp|jpeg)')


wget -q "$picURL/$wall"

rm=$(head -1 $HOME/bin/wall.txt)
rm -f $rm
rm -f wall.txt
rm -f cookies.txt
rm -f login
rm -f login.1

gsettings set org.gnome.desktop.background picture-uri "file:///$dir/$wall"

echo $wall > wall.txt
echo "$blue$wall$nc set to wallpaper";echo "$blue$html$nc - link to wallhaven.cc"


else 

 
html=$(curl -s "$site/search?q=&categories=$categories&purity=$purity&atleast=$atleast&topRange=$topRange&sorting=$sorting&order=desc&page=$random" | grep -o '<a class="preview" href="https://alpha.wallhaven.cc/wallpaper/[0-9]*"' | sed  's .\{24\}  ' | tr -d '"' | awk 'BEGIN { srand() }
{ l[NR]=$0 } END { print l[int(rand() * NR + 1)] }'  )

wall=$(curl -s "$html" | grep -Po '(?<=src="//wallpapers.wallhaven.cc/wallpapers/full/)[^"]*(jpg|png|gif|bmp|jpeg)')

cd $dir

wget -q "$picURL/$wall"

rm=$(head -1 $HOME/bin/wall.txt)
rm -f $rm
rm -f wall.txt

gsettings set org.gnome.desktop.background picture-uri "file:///$dir/$wall"

echo $wall > wall.txt
echo "$blue$wall$nc set to wallpaper";echo "$blue$html$nc - link to wallhaven.cc"

fi
## Time functions

	if [[ -z "${time}" ]] ; then #If time is not set, break loop (so the script finishes).
		break
	fi
	sleep $time
  

done

exit
