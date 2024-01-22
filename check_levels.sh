#!/bin/sh

while true
do
		timeout 6s record.sh tmp123.wav
		bs1770gain -r tmp123.wav | grep -E "integrated|range"
        sleep 5s
done

rm tmp123.wav


