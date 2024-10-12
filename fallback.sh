#!/bin/bash
# Usage: script_name.sh <directory> <source_language> <target_language>

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <directory> <source_language> <target_language>"
    exit 1
fi

# Arguments
DIR="$1"
SOURCE_LANG="$2"
TARGET_LANG="$3"

# Get the parent directory and base name of the original directory
PARENT_DIR=$(dirname "$DIR")
BASE_DIR=$(basename "$DIR")

# Create the new target directory next to the original directory
TARGET_DIR="${PARENT_DIR}/${TARGET_LANG}"

# Copy the directory
cp -r "$DIR" "$TARGET_DIR"

# Traverse the copied directory and rename files
find "$TARGET_DIR" -type f | while read -r FILE; do
    # Rename files containing the source language in their name
    NEW_FILE=$(echo "$FILE" | sed "s/_${SOURCE_LANG}/_${TARGET_LANG}/g")
    mv "$FILE" "$NEW_FILE"
    
    # Edit the content of the files
    # For macOS use "sed -i ''" and for Linux use "sed -i"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/l_${SOURCE_LANG}/l_${TARGET_LANG}/g" "$NEW_FILE"
    else
        sed -i "s/l_${SOURCE_LANG}/l_${TARGET_LANG}/g" "$NEW_FILE"
    fi
done

echo "Completed! Files have been copied, renamed, and edited from '$SOURCE_LANG' to '$TARGET_LANG'."
