# torGen
A BASH script to more quickly create torrents via mktorrent

This BASH script makes choosing flags and options for mktorrent much easier. It can be configured to use one or more trackers, either public or private.

After setting variables for desired output path of the .torrent file, current parent folder of the data, and any tracker source IDs and announce URLs, the user is presented with only three questions before automatically generating the torrent.

All usage options are interactive and not specified as varible options via command line.

The future state will check for existing command line variables and, if empty, then ask interactive questions instead. This will give flexibility of usage to the end user.

## Requirements

mktorrent installed and in the user's PATH.
Environmental variables set as noted in torgen.sh.

## Credits

Vaphell of Ubuntu Forums - https://ubuntuforums.org/showthread.php?t=1977502&p=11925610#post11925610

AirCombat & lazor of GitLab - https://gitlab.com/JimmyGregorio/makeTorrent
