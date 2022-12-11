#!/bin/bash

# create output directory if it does not exist
if [ ! -d output ]; then
  mkdir output
fi

# split file into files containing 100 IPs each
split -l 100 ips.txt output/ips_

# get the names of the split files
split_files=(output/ips_*)

# perform port scan on each set of 100 IPs in a separate tmux session
for split_file in "${split_files[@]}"; do
  # start new tmux session and run naabu on the current set of IPs and save output to file
  tmux new-session -d -s naabu$RANDOM "naabu -l $split_file -p - -o result/$split_file.txt"
  # wait until a tmux session is available before starting a new one
  while [ $(tmux ls | wc -l) -ge 5 ]; do
    sleep 1
  done
done
