# extract_torrents
For rTorrent, extract active .torrents from .sessions, with original name and same subdir structure than downloads

Usage: extract_torrents.sh [OPTION]...

This script will extract infohash.torrents from the .session directory, rename
them to their original name (or optionally like the downloaded files). 

The extracted .torrents will be copied to a base output directory with the same
subdirectory structure than their downloaded files.

  -a          Use an alternative name for the .torrent based on the downloaded
              filename or directory (for multi-file downloads).
              This makes easier to associate .torrents and downloads. 
              
  -x          Execute the commands. Without this switch the script will only
              show the commands without executing them.  
              
  -t TRACKER  Extract only .torrents from TRACKER. Use the tracker name as it
              appears in rutorrent (i.e. hdbits.org apollo.rip ....)
              
  -l LABEL    Extract only .torrents with rutorrent label LABEL.
  
  -s PATH     Full path of the .session directory including trailing slash.
              Default: "$SessionDir"
              
  -d PATH     Full path of the Download base directory including trailing slash.
              Default: "$DownloadDir"
              
  -o PATH     Full path of the Output base directory including trailing slash.
              Default: "$OutputBaseDir"
              
  -h          Display this help
