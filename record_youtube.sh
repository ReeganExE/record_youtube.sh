#!/usr/bin/env sh

usage() {
  echo "Usage: $0 [-f|--from hh:mm:ss]  [-t|--to hh:mm:ss] [-b|--best] [-V|--verbose] <youtube_link>"
}

link=
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

if [ $# -gt 1 ]; then
  shift
  echo "Unknown parameters" $@
  usage
  exit 1
fi

link=$1

if [ -z $link ]; then
  usage
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
