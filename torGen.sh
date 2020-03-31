#!/bin/bash
#
# torGen.sh by undaunt
#
# Ensure wherever mktorrent is installed that it is in the PATH.
#
# Set environmental variables (or static paths) for the data and torrent file folders
# labeled as 'data' and 'torrents' directly below this comment.
#
# Set environmental variable values (or replace directly with text) the source IDs and announce
# URLs for each tracker. Source labels, such as "RED" or "MAM", are on the 'sources' line (line XX)
# in addition to the 'Choose your tracker:' section (line xx). Announce URLs are only in
# the 'Choose your tracker:' section.
#
# The pieces size recommendations used below are based on suggested size values from
# the REDacted.ch wiki.
#
# When executing the script you'll need to answer three questions:
# 1 - Choose your tracker, 2 - Is it private, 3 - Where is the content for the torrent
#
# Released under the MIT License

# Variable list
# Hard coded locations for torrent data and torrent file output - set variables or modify
data="${CREATED_TORRENT_ROOT}"
torrents="${DOCKERDIR}/qbittorrent/torrents/"
tracker2="MAM"

# Source tag array - add more if required
sources=( "${TRACKER_ID_1}" "$tracker2" "${TRACKER_ID_3}" "${TRACKER_ID_4}" )

# Choose source flag and associated announce URL - set variables or modify, add/remove as needed
echo
echo "Choose your tracker:"
select source in "${sources[@]}"
do
  case "$source" in
    "${TRACKER_ID_1}") announce="${TRACKER_ANNOUNCE_1}"
         ;;
    "${TRACKER_ID_2}") announce="${TRACKER_ANNOUNCE_2}"
         ;;
    "${TRACKER_ID_3}") announce="${TRACKER_ANNOUNCE_3}"
         ;;
    "${TRACKER_ID_4}") announce="${TRACKER_ANNOUNCE_4}"
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
mktorrent -l $piece $flag -s $source -a "$announce" "$content" -o "$file"
echo
echo Torrent file created at $file from $content.
