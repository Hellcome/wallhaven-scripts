# Scripts

<h2>Wallrandom</h2>

Set to wallpaper random pictures from wallhaven.cc <br>

<h2>Savethis</h2>

Change your wallpaper dir in comment line.<br>
If you happen upon an awesome image that you want to keep, run the ./savethis.sh to save it to your wallpaper dir.

<h2>Features</h2>
This script more sorting options<br> 
<br> 
Command line switches are optional. The following switches are recognized.<br>
-s -- Sorting options, use favorites | random | date_added | views | toplist | revelance<br>
-r -- Range options, use 1d | 3d | 1w | 1M | 3M | 6M | 1y<br>
-c -- Categories options, use 100 - General | 110 - General + Anime | 101 - General + People | 111 - ALL  | 011 - Anime +<br> People | 010 - Anime | 001 - People<br>
-t -- Time options, use 10 | 10m | 10h<br>
-p -- Purity options, use 100 - SWF | 011 - Scetchy | 001 -NSFW (Need login, change lines in Needed for NSFW block)<br>
examle ./wallrandom.sh -s toplist -r 1M -c 010 -t 10m -p 100<br>

use -h to see help

<h2>Install</h2>

copy scripts to you home/bin
change settings scrips as you like in comment lines.
use ./wallrandom.sh ./savethis.sh
