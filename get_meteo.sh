#!/bin/bash

archdir=/pfss_fs1/ina-nwp/WRFtmp

if [ $# -eq 0 ]; then
  hr=00
else
  hr=12
fi

if [ $hr -eq 00 ]; then
  # Set date variables for the file naming
  dir=$(date -u -d "$fcdate" '+%Y-%m-%dT00:00:00')
else
  dir=$(date -u -d "$fcdate -1 day" '+%Y-%m-%dT12:00:00')
fi
DATE=$(date -u -d "$dir" '+%Y-%m-%d_%H:%M:%S')

if [ -d ${archdir}/$dir ]; then
  echo ${archdir}/$dir already there, skipping download
  exit 0 
fi

file=wrfout_d01_$DATE

# Set the URL for the file to download
url=https://cews.bmkg.go.id/storing-ina-nwp/$file

# Minimum file size in bytes (20 GB)
MIN_SIZE=$((20 * 1024 * 1024 * 1024))

# Get the file size from the server using curl
FILE_SIZE=$(curl -sI "$url" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')
if [ -z "$FILE_SIZE" ]; then
  echo "Could not get size for $url"
  exit 1
fi

echo "FILE_SIZE=$FILE_SIZE"

if [ ! -f ${file}b ]; then
  # Check if the file size is greater than or equal to the minimum size
  if [ -n "$FILE_SIZE" ] && [ "$FILE_SIZE" -ge "$MIN_SIZE" ]; then
      echo "File size is $FILE_SIZE bytes, proceeding with download..."
      # Download the file using aria2c with 10 connections
      aria2c -c -x 10 $url
      # Process the downloaded file
      cat ${file} | sed -e 's/\r$//' > ${file}a 
      mv ${file}a  ${file}b
      rm $file
      #wget --no-check-certificate $url
  else
      echo "File size is less than 20 GB ($FILE_SIZE bytes). Download cancelled."
      exit 1
  fi
fi

bash CutWRFd2.sh ${file}b .
rm ${file}b


# Move it to the final place
mv $dir $archdir/
