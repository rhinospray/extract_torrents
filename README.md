# extract_torrents

For each active torrent in **rTorrent** there are three files kept in the **.sessions** directory (defined in **.rtorrent.rc** with the **session** directive). The name of these files is the infohash (e.g.FA8B12944B7C615F13CD98B9D845116E01992E08) that uniquely identifies  the torrent, but makes difficult to correlate them to the files downloaded:

* infohash.torrent is the original .torrent renamed.
* infohash.torrent.rtorrent is a bencoded file with info and status data about the torrent.
* infohash.torrent.libtorrent_resume is a bencoded file with info to resume download and/or seeding after each restart.

estatus data a copy of the .torrent file (and two other accesory  , this scrThis script will extract active .torrents For rTorrent, extract active .torrents from .sessions, with original name and same subdir structure than downloads

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
              
    -l LABEL    Extract only .torrents with rutorrent label LABEL.
  
    -s PATH     Full path of the .session directory including trailing slash.
                Default: "$SessionDir"
              
    -d PATH     Full path of the Download base directory including trailing slash.
                Default: "$DownloadDir"
              
    -o PATH     Full path of the Output base directory including trailing slash.
                Default: "$OutputBaseDir"
              
    -h          Display this help
