#!/bin/bash
#music status helper for TinTin++
#Written by Storm Dragon

#check for last.fm:
if [ -f "$HOME/.shell-fm/nowplaying" ] ; then
artist="$(cut -f 1 -d '\' "$HOME/.shell-fm/nowplaying")"
title="$(cut -f 2 -d '\' "$HOME/.shell-fm/nowplaying")"
album="$(cut -f 3 -d '\' "$HOME/.shell-fm/nowplaying")"
if [ "$1" != false ] ; then
url="$(curl -s -G --data-urlencode longurl="$(cut -f 4 -d '\' "$HOME/.shell-fm/nowplaying")" http://is.gd/api.php)"
musicProvider="Last.fm"
fi
else
#If there was no last.fm file assume we're using cmus
musicURL="$1"
musicProvider="$2"
info="$(cmus-remote -Q)"
artist="$(echo "$info" | sed -n 's/^tag artist //p')"
title="$(echo "$info" | sed -n 's/^tag title //p')"
album="$(echo "$info" | sed -n 's/^tag album //p')"
if [ -n "$musicURL" -a "$musicURL" != false ] ; then
url="$(curl -s -G --data-urlencode longurl="$(echo "$musicURL" | sed -e 's/"/%22/g' -e 's/&/%26/g' -e "s/'/%27/g" -e 's/</%3c/g' -e 's/>/%3e/g')" http://is.gd/api.php)"
fi
fi

if [ -n "$artist" -a -n "$title" -a -n "$album" ] ; then
msg="\"$title\" by \"$artist\" from \"$album\" $url"
if [ -n "$musicProvider" ] ; then
msg="$msg (Search results provided by $musicProvider)"
fi
msg=$(echo "$msg" | tr -d "\n")
else
fileName="$(cmus-remote -Q | head -2 | tail -1 | rev)"
title="$(echo "$fileName" | cut -f 1 -d '/' | cut -f 2 -d '.' | rev)"
artist="$(echo "$fileName" | cut -f 2 -d '/' | rev)"
msg="$artist - $title"
fi
echo "$msg"
exit 0
