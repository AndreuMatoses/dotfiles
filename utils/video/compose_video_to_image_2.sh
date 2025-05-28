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

# Check if frames were extracted
if [ ! "$(ls -A frames)" ]; then
    echo "Error: No frames were extracted. Check ffmpeg command and video file."
    exit 1
fi

# Initialize the base image with the first frame
# Ensure frames are sorted to get the actual first frame
FIRST_FRAME=$(ls frames/frame_*.png | sort | head -n 1)
if [ -z "$FIRST_FRAME" ]; then
    echo "Error: Could not find the first frame."
    exit 1
fi
cp "$FIRST_FRAME" output_image.png

# Initialize previous frame variable
PREVIOUS_FRAME="$FIRST_FRAME"

# Loop through all extracted frames (sorted to ensure correct order)
for frame in $(ls frames/frame_*.png | sort); do
  # Skip the very first frame for differencing, as it's already the base
  # or use it to composite itself if you want the first object instance
  if [ "$frame" == "$FIRST_FRAME" ]; then
    # Optionally, if you want to ensure the object from the first frame is also "masked"
    # you could create a full white mask for it or use a different logic.
    # For simplicity, we'll start differencing from the second frame effectively.
    # The object in the first frame is already part of output_image.png
    PREVIOUS_FRAME="$frame"
    continue
  fi

  MASK_FILE="masks/mask_$(basename "$frame")"
  
  # Create a mask based on the difference between the current and previous frame
  # Adjust -threshold as needed (e.g., 5%-20%). Higher values are less sensitive.
  # -blur and -morphology can help clean up the mask
  convert "$frame" "$PREVIOUS_FRAME" -compose Difference -composite \
    -colorspace Gray -threshold 30% \
    -blur 0x1 -morphology Erode Disk:1 -morphology Dilate Disk:1 \
    "$MASK_FILE"

  # Composite the masked moving part of the current frame onto the base image
  convert output_image.png "$frame" "$MASK_FILE" -compose over -composite output_image.png

  # Save the intermediate composited image for debugging
  cp output_image.png debug/output_image_$(basename "$frame")

  # Update previous frame
  PREVIOUS_FRAME="$frame"
done

# Delete the frames and masks directories (optional)
rm -rf frames masks debug