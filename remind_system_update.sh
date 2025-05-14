#!/bin/bash

# Define threshold for update reminder (in days)
THRESHOLD=14  # Change this value as needed

UPDATE_DIR="$HOME/etc/updates"
LATEST_FILE=$(ls -t "$UPDATE_DIR" | grep '^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' | head -n1)

if [ -z "$LATEST_FILE" ]; then
    # No update files found, treat as very old (365 days)
    days_since=365
else
    # Extract just the date string from filename
    LAST_DATE="$LATEST_FILE"
    
    # Get today's date and convert to Unix timestamp
    TODAY=$(date +%Y-%m-%d)
    TODAY_TIMESTAMP=$(date -d "$TODAY" +%s)
    
    # Convert last update date to Unix timestamp using just the filename (not full path)
    LAST_TIMESTAMP=$(date -d "$LAST_DATE" +%s 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo "Error parsing date $LAST_DATE"
        exit 1
    fi
    
    days_since=$(( (TODAY_TIMESTAMP - LAST_TIMESTAMP) / 86400 ))
fi

if [ "$days_since" -gt "$THRESHOLD" ]; then
    # Calculate human-readable duration
    if [ "$days_since" -lt 7 ]; then
        duration="$days_since day(s)"
    elif [ "$days_since" -lt 30 ]; then
        weeks=$(( (days_since + 3) / 7 ))  # Round to nearest week
        duration="$weeks week(s)"
    else
        months=$(( days_since / 30 ))
        duration="$months month(s)"
    fi

    SCRIPT_NAME=$(basename "$0")
    MESSAGE="$SCRIPT_NAME: Please update arch linux. The last update was $duration ago."
    
    # Use espeak to announce the message
    if command -v espeak &> /dev/null; then
        espeak "$MESSAGE"
    else
        echo "espeak not found, but would have said: $MESSAGE"
    fi
fi


