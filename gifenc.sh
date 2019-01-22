#!/bin/sh

input_file="$1"
output_file="$2"

tmp_palette_file='/tmp/palette.png'

#filters="fps=15,scale=320:-1:flags=lanczos"
filters='fps=15'

ffmpeg -v warning -i "$input_file" -vf "$filters,palettegen" -y "$tmp_palette_file"
ffmpeg -v warning -i "$input_file" -i "$tmp_palette_file" -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$output_file"
