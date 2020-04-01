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
# the REDacted.ch wiki.
#
# When executing the script you'll need to answer three questions:
# 1 - Which tracker?, 2 - Is it private?, 3 - Where is the content for the torrent?
#
# Released under the MIT License

# Variable list
data="${TORRENT_DATA_ROOT}" # Torrent content parent folder
torrents="${TORRENT_FILE_ROOT}" # .torrent file destination
bin="/usr/local/bin/mktorrent"
tracker1="${TRACKER_ID_1}"
tracker2="${TRACKER_ID_2}"
tracker3="${TRACKER_ID_3}"
tracker4="${TRACKER_ID_4}"
tracker1_announce="${TRACKER_ANNOUNCE_1}"
tracker2_announce="${TRACKER_ANNOUNCE_2}"
tracker3_announce="${TRACKER_ANNOUNCE_3}"
tracker4_announce="${TRACKER_ANNOUNCE_4}"

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
echo

# Set the private flag
echo "Is this a private tracker?"
select private in "yes" "no"
do
  case "$private" in
    yes) flag="-p"
         ;;
    no)  flag=""
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
size=$(du -shm "$d" | awk '{ print $1 }')

# Set the piece size based on content size
if [ "$size" -le 52 ]
then
  piece=15
elif [ "$size" -gt 52 ] && [ "$size" -le 157 ]
  then
    piece=16
elif [ "$size" -gt 157 ] && [ "$size" -le 367 ]
  then
    piece=17
elif [ "$size" -gt 367 ] && [ "$size" -le 537 ]
  then
    piece=18
elif [ "$size" -gt 537 ] && [ "$size" -le 1073 ]
  then
    piece=19
elif [ "$size" -gt 1073 ] && [ "$size" -le 2147 ]
  then
    piece=20
elif [ "$size" -gt 2147 ]
  then
    piece=21
fi

# Create the torrent file
$bin -l $piece $flag -s $source -a "$announce" "$content" -o "$file"
echo
echo Torrent file created at $file from $content.
