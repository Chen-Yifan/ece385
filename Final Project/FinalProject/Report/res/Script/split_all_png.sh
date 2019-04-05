#!/usr/bin/bash

# Takes all PNG files in a directory and splits them into 1000x1290 parts.

for f in *.png
do
    echo "Splitting $f"
    # The ${f%.*} takes a variable that is a filename and removes its extension.
    convert -crop 1000x1290 +repage "$f" "${f%.*}%02d.png"
done
