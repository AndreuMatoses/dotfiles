#!/bin/bash

# This script extracts frames from a video file at a specified interval,
# creates masks for the moving object (assumed to be a drone), and composites
# these masked frames onto a base image to create a final output image.
# Dependencies: ffmpeg, ImageMagick

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <video_file> <interval_seconds>"
    exit 1
fi

# Define the video file name and the time interval between frames (in seconds)
VIDEO_FILE="$1"
INTERVAL="$2"

# Check if the video file exists
if [ ! -f "$VIDEO_FILE" ]; then
    echo "Error: Video file '$VIDEO_FILE' not found."
    exit 1
fi

# Create the frames directory if it doesn't exist
mkdir -p frames
mkdir -p masks
mkdir -p debug

# Extract frames from the video
ffmpeg -i "$VIDEO_FILE" -vf "fps=1/$INTERVAL" frames/frame_%04d.png

# Initialize the base image with the first frame
cp frames/frame_0001.png output_image.png

# Loop through all extracted frames
for frame in frames/frame_*.png; do
  # Non detailed way: no color masking, just normal masking
  # convert "$frame" -threshold 50% -negate masks/mask_$(basename "$frame")

  # Create a mask for the robot based on color ranges (basically see the changes in specific colors, to avoid erros where the background and robot color are similar)
  convert "$frame" \
    -fill white -fuzz 10% -opaque "rgb(15, 15, 15)" \
    -fill white -fuzz 30% -opaque "rgb(255, 253, 94)" \
    -fill white -fuzz 30% -opaque "rgb(253, 251, 249)" \
    -fill black +opaque white \
    masks/mask_$(basename "$frame")

  # Composite the masked drone onto the base image
  convert output_image.png "$frame" masks/mask_$(basename "$frame") -compose over -composite output_image.png

  # Save the intermediate composited image for debugging
  cp output_image.png debug/output_image_$(basename "$frame")

done

# Delete the frames and masks directories (optional)
rm -rf frames masks debug