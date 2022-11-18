#!/bin/bash

PLAYLIST=./failover/playlist.txt

# The RTMP endpoint, ie: your Twitch RTMP link
rtmpe="rtmp://127.0.0.1/live/"

# The RTMP ingest stream, you probaly don't need to change this if you're using failover nginx config
rtmpi="rtmp://127.0.0.1:1936/live/$SECRET_STREAM_KEY"

###############
# Don't touch #
###############
wd=/tmp/failover
pfi=$wd/failover
offpidfi=$wd/offline_pid
onpidfi=$wd/online_pid
offlo=$wd/offline_lock
onlo=$wd/online_lock