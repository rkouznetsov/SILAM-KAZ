#!/bin/bash

# Get the date of the day before yesterday in YYYYMMDD00 format
TARGET_DATE=$(date -d "2 days ago" +%Y%m%d)00

# Define the target directory path based on the date
TARGET_DIR="$HOME/silam-inanwp/bnd58/$TARGET_DATE"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR does not exist."
    # Run the get_AQ_BND.sh script if the directory is missing
    $HOME/silam-inanwp/get_AQ_BND.sh
    exit 1
fi

# Count the total number of files in the directory
FILE_COUNT=$(ls -1 "$TARGET_DIR" | wc -l)

# Count the number of .nc files specifically
NC_FILE_COUNT=$(ls -1 "$TARGET_DIR"/*.nc 2>/dev/null | wc -l)

# Check if the total number of files is 56 and all are .nc files
if [ "$FILE_COUNT" -eq 56 ] && [ "$NC_FILE_COUNT" -eq 56 ]; then
    echo "Directory $TARGET_DIR contains exactly 56 .nc files."
else
    echo "Directory $TARGET_DIR does not meet the requirements:"
    echo "Total files: $FILE_COUNT (expected 56)"
    echo ".nc files: $NC_FILE_COUNT (expected 56)"
    if [ "$FILE_COUNT" -ne 56 ]; then
        echo "The directory does not contain 56 files."
    fi
    if [ "$NC_FILE_COUNT" -ne 56 ]; then
        echo "Not all files are .nc files."
    fi
    # Run the get_AQ_BND.sh script if the requirement is not met
      mv $TARGET_DIR ${TARGET_DIR}a 
      $HOME/silam-inanwp/get_AQ_BND.sh
    exit 1
fi

