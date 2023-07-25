#!/bin/bash

LOCKARGS=""

for OUTPUT in `swaymsg -t get_outputs | jq -r '.[].name'`
do
    IMAGE=/tmp/$OUTPUT-lock.png
    grim -o $OUTPUT $IMAGE
    convert $IMAGE -blur 2x8 $IMAGE
    LOCKARGS="${LOCKARGS} --image ${OUTPUT}:${IMAGE}"
    IMAGES="${IMAGES} ${IMAGE}"
done
swaylock $LOCKARGS
rm $IMAGES
