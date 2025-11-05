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
if [ -z "$RC_PATH" ]; then
    echo "Error: RC_PATH environment variable is not set." >&2
    exit 1
fi
if [ -z "$RD_REFRESH_DIR" ]; then
    echo "Error: RD_REFRESH_DIR environment variable is not set." >&2
    exit 1
fi
if [ -z "$RC_USERNAME" ]; then
    echo "Error: RC_USERNAME environment variable is not set." >&2
    exit 1
fi
if [ -z "$RC_PASSWORD" ]; then
    echo "Error: RC_PASSWORD environment variable is not set." >&2
    exit 1
fi

# The name of the torrent, passed as the first argument (%N) from rdt-client.
TORRENT_NAME="$1"

# Construct the full source and destination paths.
SOURCE_PATH="$SOURCE_PATH_BASE/$TORRENT_NAME"
DESTINATION_PATH="$DEST_PATH_BASE/$TORRENT_NAME"

# refresh folder in async mode
rclone --config /config/rclone/rclone.conf rc vfs/refresh recursive=true --rc-addr "$RC_PATH" _async=false dir="$RD_REFRESH_DIR" _async=false --rc-user="$RC_USERNAME" --rc-pass="$RC_PASSWORD"

echo "Starting rclone copy for torrent: $TORRENT_NAME"
echo "Source: $SOURCE_PATH"
echo "Destination: $DESTINATION_PATH"

# Use rclone copy to copy the torrent directory from the local mount.
# rclone copy "$SOURCE_PATH" "$DESTINATION_PATH" --progress --error-on-no-transfer --transfers 1 --ignore-existing --ftp-concurrency 1

rclone --config /config/rclone/rclone.conf copy "$SOURCE_PATH" "$DESTINATION_PATH" --progress --transfers 1 --retries 3 --low-level-retries 100 --timeout 5m --contimeout 5m

echo "rclone copy finished."
