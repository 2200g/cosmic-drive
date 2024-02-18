#!/bin/sh

read -r -p "file:" file
file_size=$(stat -c %s "$file")

if [ $file_size -gt $((20*1024*1024)) ]; then
    echo "file is bigger than 20MB."
else
    echo "file is not bigger than 20MB."
fi


