#!/bin/bash

# Take source file name from $1 and moves it TOFILE, leaving soft-link behind
# 
# NOTE: mv is forcing overwright
# NOTE: Since it is mainly for moving system files, I made run as ROOT requirement mandatory

# Script name
readonly SCRIPT_NAME="$(basename "$0")"

# Exit codes
readonly E_RUN_AS_ROOT='1'
readonly E_IS_NOT_FILE='2'
readonly E_FILE_IS_SYMLINK='3'
readonly E_BAD_MOVE='4'
readonly E_TO_CREATE_SUMLINK='5'
readonly E_FILE_VAR_NULL='6'


readonly FILEPATH="$(realpath "$1")"

readonly FILENAME="$(basename "$FILEPATH")"

readonly TOPATH='/mnt/vault/storage/important/Personal/Technical/Configs/System/'

readonly TOFILE="$TOPATH""$FILENAME"


# Check if root
if [ $EUID != '0' ]; then
   echo "ERROR: The \"${SCRIPT_NAME}\" script must be run as root." 1>&2
   exit "$E_RUN_AS_ROOT"
fi

# Check if FILE not NULL
if [ ! "$FILEPATH" ]; then
  echo 'ERROR: ''Script does not received filename from STDIN!' >&2
  exit "${E_FILE_VAR_NULL}"
fi

# Check if file exists, not directory and not device file
if [ ! -f "$FILEPATH" ]; then
  echo 'ERROR: '"$FILEPATH"' does not exist or directory!' >&2
  exit "${E_IS_NOT_FILE}"
fi

# Check if file is not a symlink
if [ -L "$FILEPATH" ]; then
  echo 'ERROR: '"$FILEPATH"' is a symlink!' >&2
  exit "${E_FILE_IS_SYMLINK}"
fi

mv -f "$FILEPATH" "$TOFILE"
# Check if mv done without error
if [ "$?" != 0 ]; then
  echo 'ERROR: Unable to move '"$FILEPATH"' to '"$TOFILE" >&2
  exit "${E_BAD_MOVE}"
fi

ln -s "$TOFILE" "$FILEPATH"
# Check if ls done without error
if [ "$?" != 0 ]; then
  echo 'ERROR: Unable to create symlink '"$FILEPATH"' to '"$TOFILE" >&2
  exit "${E_TO_CREATE_SUMLINK}"
fi

