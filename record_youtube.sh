#!/usr/bin/env sh

link=$1
from=
to=
best=
verbose=

COMMAND_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
  -f | --from)
    from=$2
    shift 2
    ;;
  -t | --to)
    to=$2
    shift 2
    ;;
  -b | --best)
    best=1
    shift
    ;;
  -V | --verbose)
    best=1
    shift
    ;;
  *)
    COMMAND_ARGS+=("$1")
    shift
    ;;
  esac
done
set -- "${COMMAND_ARGS[@]}"

if [ -z $link ]; then
  echo "$0 [-f|--from hh:mm:ss]  [-t|--to hh:mm:ss] [-b|--best] [-V|--verbose] <youtube_link>"
  exit 1
fi

# if --best is not specified, set the default format to 1080p
format=
if [ -z $best ]; then
  format="-f 137+251"
fi

seek_opts=""
if [ ! -z $from ]; then
  seek_opts=$seek_opts" -ss $from"
fi
if [ ! -z $to ]; then
  seek_opts=$seek_opts" -to $to"
fi

seds="s/.*/$seek_opts -i &/"

echo "Getting link ..."
inputs=$(youtube-dl -g $format $link | sed "$seds")

quite="-stats -loglevel error"
if [ ! -z $verbose ]; then
  quite=""
fi

echo "Recording ..."
ffmpeg $inputs -map 0:v -map 1:a -c:v libx264 -c:a aac $quite $(date +%Y%m%d-%H%M%S).mp4
