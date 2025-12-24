#!/bin/bash

# Create the output directory if it doesn't exist
mkdir -p out

# Loop through all .pbm files in the current directory
for file in *.pbm; do
  # Extract the filename without the extension
  filename=$( basename "./$file" .pbm )

  # Convert the file to PNG
  convert "$file" "out/${filename}.png"
done

echo "Conversion complete. PNG files saved in the 'out' directory."
