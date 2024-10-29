#!/bin/bash

# Check if sufficient arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <base directory> <index>"
    exit 1
fi

# Assign arguments to variables
BASE_DIR=$1
INDEX=$2

# Navigate to the hypersim directory
cd "$BASE_DIR" || exit

# Run the Python download script with specified filters and index
./download_hypersim.py --contains 00_final_preview --contains color.jpg --silent --index "$INDEX"

# Navigate to the download folder for the current index
TARGET_DIR="$BASE_DIR/downloads/$(printf "%03d" "$INDEX")"
NS_DIR="$BASE_DIR/ns-process/$(printf "%03d" "$INDEX")"
cd "$TARGET_DIR" || exit

# Check if there is exactly one subdirectory
SUBDIR=$(find . -mindepth 1 -maxdepth 1 -type d)
if [ -d "$SUBDIR" ]; then
    # Move everything from the subdirectory to the current directory
    mv "$SUBDIR"/* .

    # Remove the now-empty subdirectory
    rmdir "$SUBDIR"
fi

cd "$BASE_DIR"
ns-process-data images --data "$TARGET_DIR" --output-dir "$NS_DIR"
rm -rf "$TARGET_DIR"
rm -rf "$NS_DIR"/images_*
rm -rf "$NS_DIR"/colmap
