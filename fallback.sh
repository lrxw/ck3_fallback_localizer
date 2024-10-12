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

# Find all "localization" folders recursively
LOCALIZATION_DIRS=$(find "$DIR" -type d -name "localization")

if [ -z "$LOCALIZATION_DIRS" ]; then
    echo "Error: No 'localization' folders found in '$DIR'."
    exit 1
fi

# Process each "localization" folder found
for LOCALIZATION_DIR in $LOCALIZATION_DIRS; do
    echo "Processing localization folder: $LOCALIZATION_DIR"

    # Search for the source language folder inside the localization directory
    SOURCE_LANG_DIR=$(find "$LOCALIZATION_DIR" -type d -name "*$SOURCE_LANG*")

    if [ -z "$SOURCE_LANG_DIR" ]; then
        echo "No folder containing the source language '$SOURCE_LANG' was found in '$LOCALIZATION_DIR'. Skipping..."
        continue
    fi

    # Create the target language folder next to the source language folder
    TARGET_LANG_DIR="${SOURCE_LANG_DIR/$SOURCE_LANG/$TARGET_LANG}"

    # Check if the target language folder already exists
    if [ -d "$TARGET_LANG_DIR" ]; then
        echo "Target language folder '$TARGET_LANG_DIR' already exists. Skipping..."
        continue
    fi

    # Copy the source language folder to create the target language folder
    cp -r "$SOURCE_LANG_DIR" "$TARGET_LANG_DIR"

    # Traverse the copied directory and rename files
    find "$TARGET_LANG_DIR" -type f | while read -r FILE; do
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

    echo "Completed processing for '$LOCALIZATION_DIR'."
done

echo "All localization folders processed."
