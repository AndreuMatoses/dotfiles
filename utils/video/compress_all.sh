#!/bin/bash
##
# This script compresses all .mp4 files in a given directory and its subdirectories. Then it saves the compressed files in a new directory 
# with the same structure as the input directory.
# Usage example: ./compress_all.sh /path/to/input_directory

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg could not be found. Please install it."
    exit 1
fi

# Check if input directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

INPUT_DIR=$(realpath "$1") # Get absolute path
OUTPUT_DIR="${INPUT_DIR}_compressed"

# Check if input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory '$INPUT_DIR' not found."
    exit 1
fi

# Create the main output directory
mkdir -p "$OUTPUT_DIR"

echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Starting compression..."

# Find all .mp4 files and process them
find "$INPUT_DIR" -type f -name "*.mp4" | while read -r input_file; do
    # Get the relative path from the input directory
    relative_path="${input_file#$INPUT_DIR/}"
    # Construct the output file path
    output_file="$OUTPUT_DIR/$relative_path"
    # Create the necessary subdirectories in the output directory
    output_subdir=$(dirname "$output_file")
    mkdir -p "$output_subdir"

    echo "Processing: $input_file -> $output_file"

    # Run ffmpeg to compress the video using NVIDIA NVENC
    # -c:v h264_nvenc: Use the NVIDIA H.264 hardware encoder
    # -preset p5: NVENC preset (p1-p7, default p5=medium, p7=slowest/best quality, p1=fastest/lowest quality)
    # -cq 25: Constant Quality level for NVENC (similar to CRF, lower=better quality, range ~0-51, adjust as needed)
    # -b:a 128k: Audio bitrate
    # -y: Overwrite output files without asking
    # -loglevel error 2>/dev/null: Suppress ffmpeg output except for errors
    ffmpeg -i "$input_file" -c:v h264_nvenc -preset p5 -cq 31 -c:a aac -b:a 128k "$output_file" -y -loglevel error 2>/dev/null

    # Run ffmpeg to compress the video using CPU
    # Adjust -crf value for quality/size trade-off (lower=better quality, larger size; higher=lower quality, smaller size)
    # Adjust -preset for encoding speed vs compression (slower=better compression)
    # ffmpeg -i "$input_file" -c:v libx264 -crf 24 -preset fast -c:a aac -b:a 128k "$output_file" -y 

    if [ $? -eq 0 ]; then
        echo "Successfully compressed: $output_file"
    else
        echo "Error compressing: $input_file"
        # Optional: remove partially created output file on error
        # rm -f "$output_file"
    fi
done

echo "Compression finished."