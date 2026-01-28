---
name: youtube-transcript
description: Extract and read transcripts from YouTube videos
---

## What I do

Extract transcripts/subtitles from YouTube videos for learning and analysis

## How to use

List available subtitles:

```sh
yt-dlp --list-subs "VIDEO_URL"
```

Download manual subtitles (higher quality, less common):

```sh
yt-dlp --write-subs --sub-lang en --sub-format vtt --skip-download -o "/tmp/%(id)s" "VIDEO_URL"
```

Fallback to auto-generated subtitles:

```sh
yt-dlp --write-auto-subs --sub-lang en --sub-format vtt --skip-download -o "/tmp/%(id)s" "VIDEO_URL"
```

Read the transcript:

- Output file: `/tmp/<video_id>.en.vtt`
- VTT format has timestamps - parse or ignore them as needed
- Clean up `/tmp/<video_id>.en.vtt` files
