#!/bin/bash

# Create a directory for the output MP3s if it doesn't exist
mkdir -p converted_mp3s

# Loop through all files in the current directory
for input_file in *; do
    # Check if the item is a regular file (not a directory or special file)
    if [ -f "$input_file" ]; then
        # Extract the filename without its extension
        # This handles files like "my video.mp4" -> "my video"
        filename_no_ext="${input_file%.*}"

        # Define the output MP3 file path in the new directory
        output_file="converted_mp3s/${filename_no_ext}.mp3"

        echo "Converting '$input_file' to '$output_file'..."

        # Use ffmpeg to convert the video to MP3
        # -i "$input_file": Specifies the input file.
        # -vn: Disables video recording (ensures only audio is processed).
        # -q:a 2: Sets the audio quality for MP3. '2' is a good variable bitrate (VBR)
        #         quality, often equivalent to around 192-256kbps.
        #         Lower numbers (e.g., 0) mean higher quality, higher numbers (e.g., 9) mean lower quality.
        #         This option typically uses the 'libmp3lame' encoder, which provides high-quality MP3s.
        # "$output_file": Specifies the output MP3 file.
        ffmpeg -i "$input_file" -vn -q:a 2 "$output_file"

        # Check the exit status of the ffmpeg command
        if [ $? -eq 0 ]; then
            echo "Successfully converted '$input_file'."
        else
            echo "Error converting '$input_file'. Please check the file or ffmpeg output."
        fi
    fi
done

echo "All conversions attempted. Check the 'converted_mp3s' directory."
```

### How to use it:

1.  **Save the script:** Open a text editor (like `nano` or `vim`), paste the code, and save it as something like `convert_videos_to_mp3.sh`.
2.  **Make it executable:**
    ```bash
    chmod +x convert_videos_to_mp3.sh
    ```
3.  **Navigate to your folder:** Use `cd` to go into the directory where your video files are located.
    ```bash
    cd /path/to/your/videos
    ```
4.  **Run the script:**
    ```bash
    ./convert_videos_to_mp3.sh
