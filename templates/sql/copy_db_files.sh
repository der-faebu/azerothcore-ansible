#!/bin/bash

MODULES_DIR="$SOURCE/modules/"
TARGET_DIR="$INSTALL_DIR/data/sql/custom"

echo "[INFO] Creating target directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "[INFO] Scanning modules in $MODULES_DIR"
for module in "$MODULES_DIR"/*; do
    module_name=$(basename "$module")

    if [ "$module_name" == "mod-playerbots" ]; then
        echo "[SKIP] Skipping module: $module_name"
        continue
    fi

    if [ -d "$module/data/sql" ]; then
        echo "[INFO] Processing module: $module_name"
        find "$module/data/sql" -type d | while read -r dir; do
            rel_path=$(echo "${dir#$module/data/sql/}" | sed 's/-/_/g')
            target="$TARGET_DIR/$rel_path"
            echo "[INFO] Creating directory: $target"
            mkdir -p "$target"

            sql_files=$(find "$dir" -maxdepth 1 -type f -name "*.sql")
            for file in $sql_files; do
                echo "[COPY] Copying $(basename "$file") to $target"
                cp "$file" "$target/"
            done
        done
    else
        echo "[WARN] No SQL directory in module: $module_name"
    fi
done

echo "[DONE] SQL files copied and structured under $TARGET_DIR."
