#!/bin/bash
# Update all git directories below current directory or specified directory
# Skips directories that contain a file called .ignore

find . -name .git -type d -prune | while read d; do
  cd $d/..
  echo "$PWD"
  cd $OLDPWD
done
