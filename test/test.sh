#!/bin/bash
# Find all first files of a VOB Title and write them to variable
VOB_FILES=
VOB_FILES="$(find . -name "VTS_[0-9][1-9]_1.VOB" -print)"

VOB_PCM=''
export VOB_PCM

# loop for finding out all PCM streams in VOB files variable
while read LINE; do
  echo 'Search in '"$LINE"
  # get mediainfo input for file
  ## grep Audio stanza
  ## grep only that have PCM type (presumably it is 189 (0xBD)-160
  ## grep only ^Audio* line after that, to get 
  PCM_CHANNEL="$(mediainfo "$LINE"|grep -A15 "^Audio"|grep -B1 -A1 '189 (0xBD)-160'|grep Audio)"
  #|sed -e 's/^Audio//g'|sed -e 's/^[ ]#//g')"
  # mediainfo "--Inform=Audio;%Format%" "$LINE"|grep PCM
  
   if [ -z "$PCM_CHANNEL" ]; then
     # echo 'Empty!'
     # go to new iteration
     continue
   fi
   
   if [ "$PCM_CHANNEL"=='\n' ];then
     PCM_CHANNEL='0'
   fi
   
   # add VOB PCM line to variable
   echo 'Found PCM audio in '"$PCM_CHANNEL"
   VOB_PCM="$VOB_PCM""$LINE"$'\n'
#    VOB_STREAM="$VOB_PCM""$LINE"$'\n'
   
done <<< "$VOB_FILES"
# echo "VOB_FILES"
# echo "$VOB_FILES"
echo $'\n''List of PCM found VOBs'
echo "$VOB_PCM"

while read LINE; do

DIR="$(dirname "$VOB_PCM")"
NAME="$(basename "$VOB_PCM")"

VOB_PCM_GLOB="$(echo "$LINE"|sed -e 's/_1.VOB//g')"

echo "$VOB_PCM_GLOB"
# echo "$DIR"
# echo "$NAME"

TEMPODIR='/run/media/pyro/4358578b-c30b-4b86-82c4-f243b5ec09db/home/taras/Документи/Anton-temp'
VOB_PCM_GLOB="$VOB_PCM_GLOB""*.VOB"

echo "$VOB_PCM_GLOB"
echo "cat \"$VOB_PCM_GLOB\"| ffmpeg -i - -map 0:0 -vcodec copy -acodec flac \"TEMPODIR\"/\"$DIR\"/\"$NAME\".mka"
done <<< "$VOB_PCM"
