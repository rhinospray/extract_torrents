# extract_torrents.sh

For **rTorrent** users, this bash script will extract the original .torrents corresponding to all or a part of the active torrents. The .torrents will be created in an output directory with a subdirectory structure identical to the one used for downloads.

### Install

To install, just download to your preferred location, make executable, and edit to modify the default paths at the first lines of the script:
* **SessionDir** is the *.sessions* directory as defined by the **session=** directive in *.rtorrent.rc*
* **DownloadDir** is the base directory for torrent downloads as defined by the **directory=** directive in *.rtorrent.rc*
* **OutputBaseDir** is the base directory where the .torrent files will be extracted

### Details

For each active torrent in **rTorrent** there are three files kept in the *.sessions* directory. The name of these files is an infohash that uniquely identifies the torrent (e.g.FA8B12944B7C615F13CD98B9D845116E01992E08), but it makes difficult to correlate them to the files downloaded:

* _infohash.torrent_ is the original .torrent renamed.
* _infohash.torrent.rtorrent_ is a bencoded file with info and status data about the torrent.
* _infohash.torrent.libtorrent_resume_ is a bencoded file with info to resume download and/or seeding after each restart.

This script will extract bencoded data from the first two files, like original .torrent name, download name and path, tracker, label...estatus data a copy of the .torrent file (and two other accesory  , this scrThis script will extract active .torrents For rTorrent, extract active .torrents from .sessions, with original name and same subdir structure than downloads

Usage: `extract_torrents.sh [OPTION]...`

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
              
    -l LABEL    Extract only .torrents that have that specific rutorrent label.
  
    -s PATH     Full path of the .session directory including trailing slash.
                Default: "$SessionDir"
              
    -d PATH     Full path of the Download base directory including trailing slash.
                Default: "$DownloadDir"
              
    -o PATH     Full path of the Output base directory including trailing slash.
                Default: "$OutputBaseDir"
              
    -h          Display this help
