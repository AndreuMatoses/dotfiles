#!/bin/bash

# Set default CRF value. use like this: ./convert_batch_mov2mp4.sh 23
crf_value=23

# Check if an argument is provided
if [ ! -z "$1" ]; then
  crf_value=$1
fi

for file in *.MOV; do
  echo "Converting $file..."
  ffmpeg -i "$file" -c:v libx264 -crf 23 -an "${file%.MOV}.mp4"
done

echo "Conversion complete."

# Ask the user if they want to delete the original .MOV files
read -p "Do you want to delete the original .MOV files? (y/n) " answer

if [[ $answer = [Yy]* ]]; then
  for file in *.MOV; do
    echo "Deleting $file..."
    rm "$file"
  done
  echo "Original .MOV files deleted."
else
  echo "Original .MOV files kept."
fi