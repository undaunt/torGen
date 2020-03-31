#!/bin/bash
# Create torrents for a specified tracker with mktorrent

# Hard code locations for torrent data and torrent file output - customize as desired
data="${CREATED_TORRENT_ROOT}"
torrents="${DOCKERDIR}/qbittorrent/torrents/"

# Source tag array - add more if required
sources=( "${TRACKER_ID_1}" "${TRACKER_ID_2}" "${TRACKER_ID_3}" "${TRACKER_ID_4}" )

# Choose source flag and associated announce URL - add more if required
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
printf "Select the data folder:\n"
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
