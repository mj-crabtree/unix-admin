#!/bin/bash

filetype=`file -sik $1 | cut -d' ' -f2`

if [ $filetype = "text/plain;" ]
then
    echo "regular file of type $filetype"
elif [ $filetype = "cannot" ]
then
    echo "error: file not found."
    exit 1
else
    echo "irregular file of type $filetype."
fi

exit 0

# file $1 | grep 'ASCII' && echo 'its a regular file' || echo "its not a regular file"