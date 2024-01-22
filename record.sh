#!/bin/sh

#arecord -f cd --device="hw:3,0" > $1 2> /dev/null
arecord -f cd > $1 2> /dev/null
