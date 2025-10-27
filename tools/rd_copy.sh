#!/bin/sh

# Check for required environment variables
if [ -z "$SOURCE_PATH_BASE" ]; then
    echo "Error: SOURCE_PATH_BASE environment variable is not set." >&2
    exit 1
fi
if [ -z "$DEST_PATH_BASE" ]; then
    echo "Error: DEST_PATH_BASE environment variable is not set." >&2
    exit 1
fi

# The name of the torrent, passed as the first argument (%N) from rdt-client.
TORRENT_NAME="$1"

# Construct the full source and destination paths.
SOURCE_PATH="$SOURCE_PATH_BASE/$TORRENT_NAME"
DESTINATION_PATH="$DEST_PATH_BASE/$TORRENT_NAME"

echo "Starting rclone copy for torrent: $TORRENT_NAME"
echo "Source: $SOURCE_PATH"
echo "Destination: $DESTINATION_PATH"

# Use rclone copy to copy the torrent directory from the local mount.
/config/rclone/rclone copy "$SOURCE_PATH" "$DESTINATION_PATH" --progress --error-on-no-transfer --transfers 1 --ignore-existing --ftp-concurrency 1

echo "rclone copy finished."