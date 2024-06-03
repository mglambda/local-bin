#!/bin/bash


USAGE="Usage: $0 <number_of_latest_files> <directory>"

if [ -z $1 ] || [ -z $2 ]
then
    echo "$USAGE"
    exit
fi


ls -Art $2 | tail -n $1 | while read -r w
do
    f="$2/${w}"
    ln -s "${f}"
done
