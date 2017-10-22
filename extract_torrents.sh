#!/bin/bash
#--Default configuration data: modify for your installation
SessionDir="/home/rhino/.sessions/"
DownloadDir="/home/rhino/torrents/"
OutputBaseDir="/home/rhino/.torrents/"
#------------------USAGE HELP------------------------------------------------->
function usage {
	cat <<EOM
Usage: $(basename "$0") [OPTION]...

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
EOM

	exit 2
}
#------------------PARSE OPTIONS---------------------------------------------->
# init switch flags
filterTracker=""
filterLabel=""
altname=0
execute=0

while getopts ":s:d:o:t:l:axh" optKey; do
	case $optKey in
		s)
			SessionDir="$OPTARG"
      if [ ! -d "$SessionDir" ];then
      	echo "ERROR: Parameter -s path ($SessionDir) doesn't exist"
      	exit 2
      fi
			;;
		d)
			DownloadDir="$OPTARG"
      if [ ! -d "$DownloadDir" ];then
      	echo "ERROR: Parameter -d path ($DownloadDir) doesn't exist"
        exit 2
      fi
			;;
		o)
			OutputBaseDir="$OPTARG"
			;;
		t)
			filterTracker="$OPTARG"
      echo "Will extract only .torrents for $filterTracker"
			;;
		l)
			filterLabel="$OPTARG"
			;;

		a)
			altname=1
      echo "Will use alternative names for the .torrents"
			;;
		x)
			execute=1
			;;
		h|*)
			usage
			;;
	esac
done

shift $((OPTIND - 1))

#------------------DEFINE FUNCTIONS------------------------------------------->
# sustitute urlencoded characters like %20 by normal characters
urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
# extract the value of key $1 from a bencoded file $2  ej:  bdecode x-filename  bencoded.txt
bdecode() {
	local key="${#1}:$1"
	local value=$(sed  -nE -e "s/^.*$key//p" $2)
	local valueLen=$(echo $value | cut -d: -f1)
	local valueText=$(echo "$value" | cut -d: -f2-)
  if [ "$valueLen" = "0" ]; then
  	echo ""
  else
  	echo "$valueText" | cut -c1-$valueLen
  fi
}
# quote special metacharacters with \
metaquote() {
	printf %s "$1" | sed 's/[][{}()\/.^$?*+]/\\&/g'
}

#------------------MAIN CODE-------------------------------------------------->
# --be sure that there is a trailing slash on the paths
SessionDir="${SessionDir%/}/"
DownloadDir="${DownloadDir%/}/"
OutputBaseDir="${OutputBaseDir%/}/"

# --process the .torrent files in .session
for torfile in "$SessionDir"*.torrent
do
  rtorfile="$torfile.rtorrent"
#	--extract tracker name (as shown in rutorrent, i.e. hdbits.org ) from hash.torrent (key=announce)
	announce="$(bdecode announce $torfile)"
  domain="$(echo $announce  | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/")"
  tracker="$(echo $domain | rev | cut -d. -f-2 | rev )"
  if [ "$filterTracker" != "" ] && [ "$filterTracker" != "$tracker" ]  ; then
    printf "."
  	continue
  fi
# --extract rutorrent label from hash.rtorrent (key=custom1
	label="$(bdecode custom1 $rtorfile)"
  label="$(urldecode $label)"
  if [ "$filterLabel" != "" ] && [ "$filterLabel" != "$label" ]  ; then
    printf "."
    continue
  fi
# --extract the original xxx.torrent name from hash.rtorrent (key=x-filename, urlencoded)
	TorrName="$(bdecode x-filename $rtorfile)"
	TorrName=$(urldecode $TorrName)
# --extract the filename (or directory if multifile) of the download from hash.torrent (key=name)
	DownName=$(bdecode name $torfile)
  DownNameQ=$(metaquote "$DownName")
# --extract full download path from hash.rtorrent (key=directory)
	DownPath="$(bdecode directory $rtorfile)"
#		-- take out the last path segment when it is a multifile download to a directory
    DownPathS=$(printf %s "$DownPath" | sed -E -e "s/$DownNameQ//g")
#		-- take out the trailing slash to unify (sometimes is not present)
    DownPathS=$(printf %s "$DownPathS" | sed -e "s/\/$//g")
#		-- replace DownloadDir with OutputBaseDir
	DownloadDirQ=$(metaquote "$DownloadDir")
  OutputBaseDirQ=$(metaquote "$OutputBaseDir")
	OutputPath=$(printf %s "$DownPathS" | sed -E -e "s/$DownloadDirQ/$OutputBaseDirQ/g")
# --extract hash file name
  HashName=$(echo "$torfile" | grep -o '[^/]*$' )

#    echo "----- $torfile"
#    echo "DOMAIN=$domain TRACKER=$tracker LABEL=$label"
#    echo "REALNAME=$TorrName"
#    echo "ALTNAME=$DownName"
#    echo "ALTNAMEQ=$DownNameQ"
#    echo "TARGETDIR=$OutputPath"

# --use alternative name if requested or when real name not valid
  if [ $altname -eq 1 ] || [ "$TorrName" == "" ] || [ "$TorrName^^" == "$HashName^^" ] ; then
  	TorrName="$DownName.torrent"
  fi
# --execute the mkdir/cp commands if -x, or just explain what will do
  if [ $execute -eq 1 ]; then
  	printf "o"
  	mkdir -p "$OutputPath"
  	cp "$torfile" "$OutputPath/$TorrName"
  else
  	printf "\ncp $HashName to $OutputPath/$TorrName"
  fi
done
