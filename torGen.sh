#!/bin/bash
#
# torGen.sh by undaunt
#
# Set environmental variables (or full static paths) for the data and torrent file folders
# labeled as 'data' and 'torrents' directly below this comment. (lines 23-24)
#
# Below that, set environmental variable values (or replace directly with text) the source
# IDs and announce URLs for each tracker. Source label examples are "RED" or "MAM" while
# announce URLs are longer, such as https://flacsfor.me/xxxxx/announce.
#
# The pieces size recommendations used below are based on suggested size values from
# the MyAnonamouse wiki in lieu of REDacted.ch guidance.
#
# When executing the script you'll need to answer three questions:
# 1 - Which tracker?, 2 - Is it private?, 3 - Where is the content for the torrent?
#
# Released under the MIT License

# Variable list
data="${TORRENT_DATA_ROOT}" # Torrent content root folder - for interactive mode only
torrents="${TORRENT_FILE_ROOT}" # .torrent file destination - for interactive mode only
bin="/usr/local/bin/mktorrent" # mktorrent path
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # current directory
execute="$( bin -l $piece $flag -s $source -a "$announce" "$content" -o "$file" )"
tracker1="${TRACKER_ID_1}"
tracker2="${TRACKER_ID_2}"
tracker3="${TRACKER_ID_3}"
tracker4="${TRACKER_ID_4}"
tracker1_announce="${TRACKER_ANNOUNCE_1}"
tracker2_announce="${TRACKER_ANNOUNCE_2}"
tracker3_announce="${TRACKER_ANNOUNCE_3}"
tracker4_announce="${TRACKER_ANNOUNCE_4}"

# Check for level of interactivity
if [[ $# -ge 4 ]];
then
  echo Non-interactive mode executing.
  content=$1
  file=$2
  source=$3
  private=$4

  if [[ $source == $tracker1 ]]; then
    announce="tracker1_announce"
  elif [[ $source == $tracker2 ]]; then
    announce="tracker2_announce"
  elif [[ $source == $tracker3 ]]; then
    announce="tracker3_announce"
  elif [[ $source == $tracker4 ]]; then
    announce="tracker4_announce"
  fi

  if [[ $private == "true" ]]; then
    flag="-p"
  else
    flag=""
  fi

if [[ -e "$source" || -d "$source" ]]; then
  size=$( du -m -c "$source" | tail -1 | grep -Eo ^[0-9]+ )
  # Set the piece size based on content size
  if [ "$size" -le 69 ]; then
    piece=15
  elif [ "$size" -ge 63 ] && [ "$size" -le 137 ]; then
      piece=16
  elif [ "$size" -ge 125 ] && [ "$size" -le 275 ]; then
      piece=17
  elif [ "$size" -ge 250 ] && [ "$size" -le 550 ]; then
      piece=18
  elif [ "$size" -ge 500 ] && [ "$size" -le 1100 ]; then
      piece=19
  elif [ "$size" -ge 1000 ] && [ "$size" -le 2200 ]; then
      piece=20
  elif [ "$size" -ge 1950 ] && [ "$size" -le 4300 ]; then
      piece=21
  elif [ "$size" -ge 3900 ] && [ "$size" -le 8590 ]; then
      piece=22
  elif [ "$size" -ge 7810 ]; then
      piece=23
  fi

  echo execute

else
# Source tag array - add more if required
sources=( "$tracker1" "$tracker2" "$tracker3" "$tracker4" )

# Choose source flag and associated announce URL - set variables or modify, add/remove as needed
echo
echo "Choose your tracker:"
select source in "${sources[@]}"
do
  case "$source" in
    "$tracker1") announce="tracker1_announce"
         ;;
    "$tracker2") announce="tracker2_announce"
         ;;
    "$tracker3") announce="tracker3_announce"
         ;;
    "$tracker4") announce="tracker4_announce"
         ;;
  esac
  break
done
fi

# Set the private flag
echo
echo "Is this a private tracker?"
select private in "yes" "no"
do
  case "$private" in
    true) flag="-p"
         ;;
    false)  flag=""
         ;;  
  esac
  break
done
echo

cd "$data"

# Print current subfolders of data path as menu choices
printf "Select the torrent content folder:\n"
select d in */; do test -n "$d" && break; echo ">>> Invalid Folder Selection"; done

# Set the full torrent content directory and output file location
content="$PWD"/"${d%/}"
file="${torrents%/}"/"${d%/}".torrent
echo

# Capture the size for torrent
#size=$(du -sm "$d" | awk '{ print $1 }')
size=$( du -m -c "$d" | tail -1 | grep -Eo ^[0-9]+ )

# Set the piece size based on content size
if [ "$size" -le 69 ]; then
  piece=15
elif [ "$size" -ge 63 ] && [ "$size" -le 137 ]; then
    piece=16
elif [ "$size" -ge 125 ] && [ "$size" -le 275 ]; then
    piece=17
elif [ "$size" -ge 250 ] && [ "$size" -le 550 ]; then
    piece=18
elif [ "$size" -ge 500 ] && [ "$size" -le 1100 ]; then
    piece=19
elif [ "$size" -ge 1000 ] && [ "$size" -le 2200 ]; then
    piece=20
elif [ "$size" -ge 1950 ] && [ "$size" -le 4300 ]; then
    piece=21
elif [ "$size" -ge 3900 ] && [ "$size" -le 8590 ]; then
    piece=22
elif [ "$size" -ge 7810 ]; then
    piece=23
fi

# Check if torrent already exists, then create the torrent file
echo $execute
echo
echo Torrent file created at $file from $content.
