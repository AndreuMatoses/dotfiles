#!/bin/bash

# This script extracts frames from a video file at a specified interval,
# creates masks for the moving object (assumed to be a drone), and composites
# these masked frames onto a base image to create a final output image.
# Dependencies: ffmpeg, ImageMagick

# Define the video file name and the time interval between frames (in seconds)
VIDEO_FILE="input_video.mp4"
INTERVAL=1

# Create the frames directory if it doesn't exist
mkdir -p frames
mkdir -p masks

# Extract frames from the video
ffmpeg -i "$VIDEO_FILE" -vf "fps=1/$INTERVAL" frames/frame_%04d.png

# Initialize the base image with the first frame
cp frames/frame_0001.png output_image.png

# Loop through all extracted frames
for frame in frames/frame_*.png; do
  # Create a mask for the drone (assuming the drone is the only moving object)
  convert "$frame" -threshold 50% -negate masks/mask_$(basename "$frame")

  # Composite the masked drone onto the base image
  convert output_image.png "$frame" masks/mask_$(basename "$frame") -compose over -composite output_image.png
done

# Delete the frames and masks directories (optional)
rm -rf frames masks