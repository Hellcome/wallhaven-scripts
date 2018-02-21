#!/bin/bash

##
blue="$(tput setaf 4)"
nc="$(tput sgr0)"
##Wallhaven setings
site=https://alpha.wallhaven.cc

sorting=toplist #Relevance / Random / Date Added / Views / Favorites / Toplist
purity=100 #if you want to use NSFW, change this to 001, and enter your username and password in the box Needed for NSFW
categories=011 # 100 - General / 110 General + Anime / 111 ALL / 011 Anime + People / 010 - Anime / 001 - People / 111 - People + General
attleast=1920x1080 # your resolution
topRange=3M # sort by date 1d / 3d / 1w / 1M / 3M / 6M / 12M / 1y
random=$(shuf -i1-5 -n1) # specify the desired number of pages. Сhane this -i1-5
dir=$HOME/bin #your scripts dir
picURL=https://alpha.wallhaven.cc/wallpapers/full
siteURL="$site/search?q=&categories=$categories&purity=$purity&atleast=$atleast&topRange=$topRange&sorting=$sorting&order=desc&page=$random"

#####################################
###   Needed for NSFW   ###
#####################################
# Enter your Username
USER=""
# Enter your password
# if your password contains ' you need to escape it
# replace all ' with '"'"'
PASS=""
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


# time flag

while getopts ":d:rt:" o; do 
  case $o in
    t) time=$OPTARG;;
    nsfw) nsfw=$OPTARG
  esac
done

##

while true ; do



if  [ "$purity" == 001 ]

then

    cd $dir  

    login "$USER" "$PASS"

    html=$(curl -s --cookie cookies.txt "$siteURL" | grep -o '<a class="preview" href="https://alpha.wallhaven.cc/wallpaper/[0-9]*"' | sed  's .\{24\}  ' | tr -d '"' | awk 'BEGIN { srand() }
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

 
 html=$(curl -s "$siteURL" | grep -o '<a class="preview" href="https://alpha.wallhaven.cc/wallpaper/[0-9]*"' | sed  's .\{24\}  ' | tr -d '"' | awk 'BEGIN { srand() }
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
