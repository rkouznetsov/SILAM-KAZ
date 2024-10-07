#!/bin/bash

# Navigate to the working directory
cd /home/bik/silam-inanwp/WRF

# Set date variables for the file naming
dir=$(date -d "today 00:00" '+%Y-%m-%dT%H:%M:%S')
DATE=$(date -d "today 00:00" '+%Y-%m-%d_%H:%M:%S')
file=wrfout_d01_$DATE
fileout=${dir}${file}

# Set the URL for the file to download
url=https://cews.bmkg.go.id/storing-ina-nwp/$file

# Minimum file size in bytes (20 GB)
MIN_SIZE=$((20 * 1024 * 1024 * 1024))

# Get the file size from the server using curl
FILE_SIZE=$(curl -sI "$url" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')

# Check if the file size is greater than or equal to the minimum size
if [ -n "$FILE_SIZE" ] && [ "$FILE_SIZE" -ge "$MIN_SIZE" ]; then
    echo "File size is $FILE_SIZE bytes, proceeding with download..."
    # Download the file using aria2c with 10 connections
    aria2c -c -x 10 $url
    #wget --no-check-certificate $url
else
    echo "File size is less than 20 GB ($FILE_SIZE bytes). Download cancelled."
    exit 1
fi

# Process the downloaded file
cat ${file} | sed -e 's/\r$//' > ${file}a
bash CutWRFd2.sh ${file}a .

# Cleanup the original and temporary files
rm $file
cp -r $dir ~/pfss_fs1/ina-nwp/WRF/
rm ${file}a

# Combine the downloaded file into a folder
bash CombinedTime.sh
