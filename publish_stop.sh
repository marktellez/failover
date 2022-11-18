#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"
. "$DIR/util.sh"

me="`basename $0`"

exec 199>$offlo
if ! flock -xn 199; then
	errcho "[$me] Failed to aquire lock, exiting..." && exit 1
fi

cleanup(){
	if [[ -f $offpidfi ]]; then
		errcho "[$me] Removing Offline pid file..."
		rm -f $offpidfi
	fi
	errcho "[$me] Removing Offline lock file..."
	flock -u 199
	flock -xn 199 && rm -f $offlo
}

trap cleanup EXIT

if [[ -f $onpidfi ]]; then
	onpid=$(<$onpidfi)
	errcho "[$me] Stopping online stream (pid $onpid)..."
	rm -f $onpidfi
	kill $onpid
fi

errcho "[$me] Starting offline stream..."
ffmpeg -f concat -safe 0 -stream_loop -1 -re -safe 0 $PLAYLIST -c copy -reserve_index_space 50k -f mpegts pipe:1 > $pfi &
offpid=$!
errcho "[$me] Offline stream pid $offpid"
echo $offpid > $offpidfi
wait $offpid
