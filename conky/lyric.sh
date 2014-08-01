#!/usr/bin/env bash

artist=`audtool current-song-tuple-data artist`
title=`audtool current-song-tuple-data title`
lyrics=`glyrc lyrics --artist "$artist" --title "$title" --write 'stdout' --cache /home/erebos/.conky/lyric_cache -v 0`

# print line by line, to prevent conky from needing a large buffer
printf %s "$lyrics" | while IFS= read -r line
do
   echo "$line"
done

