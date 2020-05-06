#!/bin/bash
#
# torGen.sh by undaunt
#
# Set environmental variables (or full static paths) for the torrent file folder
# labeled 'torrents' directly below this comment.
#
# Below that, set environmental variable values (or replace directly with text) the source
# IDs and announce URLs for each tracker. Directly below that
# set the folders where new content to be uploaded sits for each tracker.
#
# The music pieces size recommendations used below are based on suggested size values from
# a well-regarded music tracker wiki.
#
# The movie pieces size recommendations used below are based on suggested size values from
# a well-regarded movie tracker set of guidelines.
#
# When executing the script you'll need to answer three questions:
# 1 - Which tracker?, 2 - What type of content?, 3 - Where is the content for the torrent?
#
# Released under the MIT License

# Variable list
torrents="${TORRENT_FILE_ROOT}" # .torrent file destination
bin="/usr/local/bin/mktorrent"
tracker1="${TRACKER_ID_1}" # Tracker source
tracker2="${TRACKER_ID_2}"
tracker3="${TRACKER_ID_3}"
tracker4="${TRACKER_ID_4}"
tracker1_announce="${TRACKER_ANNOUNCE_1}" # Tracker personal announce URL
tracker2_announce="${TRACKER_ANNOUNCE_2}"
tracker3_announce="${TRACKER_ANNOUNCE_3}"
tracker4_announce="${TRACKER_ANNOUNCE_4}"
tracker1_data="${TRACKER_DATA_1}" # Tracker specific content parent folder
tracker2_data="${TRACKER_DATA_2}"
tracker3_data="${TRACKER_DATA_3}"
tracker4_data="${TRACKER_DATA_4}"

# Source tag array - add more if required
sources=( "$tracker1" "$tracker2" "$tracker3" "$tracker4" )

# Choose source flag and associated announce URL - set variables or modify, add/remove as needed
echo
echo "Choose your tracker:"
select source in "${sources[@]}"
do
  case "$source" in
    "$tracker1") announce="$tracker1_announce" data="$tracker1_data"
         ;;
    "$tracker2") announce="$tracker2_announce" data="$tracker2_data"
         ;;
    "$tracker3") announce="$tracker3_announce" data="$tracker3_data"
         ;;
    "$tracker4") announce="$tracker4_announce" data="$tracker4_data"
         ;;
  esac
  break
done
echo

# Get content type for pieze sizing
echo "What type of content is this?"
select content in "music" "movie"
do
  case "$content" in
    music) type="music"
           ;;
    movie) type="movie"
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

# Set the piece size based on content size and type
if [ "$type" == "music" ]
then
  if [ "$size" -le 50 ]
  then
    piece=15
  elif [ "$size" -gt 50 ] && [ "$size" -le 150 ]
    then
      piece=16
  elif [ "$size" -gt 150 ] && [ "$size" -le 350 ]
    then
      piece=17
  elif [ "$size" -gt 350 ] && [ "$size" -le 512 ]
    then
      piece=18
  elif [ "$size" -gt 512 ] && [ "$size" -le 1024 ]
    then
      piece=19
  elif [ "$size" -gt 1024 ] && [ "$size" -le 2048 ]
    then
      piece=20
  elif [ "$size" -gt 2048 ]
    then
      piece=21
  fi
elif [ "$type" == "movie" ]
then
  if [ "$size" -le 70 ]
    then
      piece=16
  elif [ "$size" -gt 70 ] && [ "$size" -le 147 ]
    then
      piece=17
  elif [ "$size" -gt 147 ] && [ "$size" -le 256 ]
    then
      piece=18
  elif [ "$size" -gt 256 ] && [ "$size" -le 533 ]
    then
      piece=19
  elif [ "$size" -gt 533 ] && [ "$size" -le 1106 ]
    then
      piece=20
  elif [ "$size" -gt 1106 ] && [ "$size" -le 2294 ]
    then
      piece=21
  elif [ "$size" -gt 2294 ] && [ "$size" -le 4762 ]
    then
      piece=22
  elif [ "$size" -gt 4762 ] && [ "$size" -le 8233 ]
    then
      piece=23
  elif [ "$size" -gt 8233 ]
    then
      piece=24
  fi
fi

# Create the torrent file
$bin -l $piece -p -s $source -a "$announce" "$content" -o "$file"
echo
echo Torrent file created at $file from $content.
