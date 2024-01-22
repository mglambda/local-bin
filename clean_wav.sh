#!/bin/sh

sox roomtone.wav -n noiseprof roomtone.prof
sox $1 clean.wav noisered roomtone.prof 0.2
ffmpeg -i clean.wav -acodec flac clean.flac
rm clean.wav
rm roomtone.prof
