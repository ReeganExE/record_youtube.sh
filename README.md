# Record a part of youtube video

You found a funny moment in a movie and you just want to download that part without downloading the whole long video. This utility is for you.

```sh
./record_youtube.sh  [-f|--from hh:mm:ss]  [-t|--to hh:mm:ss] [-b|--best] [-V|--verbose] <youtube_link>
```

The default quality is 1080p, if your video isn't good enough, try `--best` option.

## Example

```sh
# Extract from 03:50 to 04:50
./record_youtube.sh --from 03:50 --to 04:50 https://www.youtube.com/watch?v=xrrOOxlWkyM

# Download the whole video
./record_youtube.sh https://www.youtube.com/watch?v=cMg8KaMdDYo
```

## Prerequisite
- [ffmpeg](https://ffmpeg.org/download.html)
- [youtube-dl](https://github.com/ytdl-org/youtube-dl)
