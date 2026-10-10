#!/bin/bash


DIR="${1:-./watch_dir}"
MALICIOUS_DIR="${2:-./quarantine_dir}"
cd "$(dirname "$0")" || exit

whitelist_file=".whitelist"

mkdir -p "$MALICIOUS_DIR"
touch "$whitelist_file" 2>/dev/null || true

flagged_extensions=(".exe" ".bat" ".vbs" ".scr" ".ps1")
flagged_keywords=("virus" "trojan" "malware" "worm" "ransomware")

scan_dir() {
    for filepath in "$DIR"/*; do
        [ -e "$filepath" ] || continue
        
        filename=$(basename "$filepath")
        is_malicious=0
        
        if grep -Fxq "$filename" "$whitelist_file" 2>/dev/null; then
            continue
        fi
        
        for ext in "${flagged_extensions[@]}"; do
            if [[ "$filename" == *"$ext" ]]; then
                is_malicious=1
                break
            fi
        done
        
        if [ $is_malicious -eq 0 ]; then
            for keyword in "${flagged_keywords[@]}"; do
                if grep -iq "$keyword" "$filepath"; then
                    is_malicious=1
                    break
                fi
            done
        fi
        
        if [ $is_malicious -eq 1 ]; then
            echo "$filename is malicious and it is DELETED"
            cp "$filepath" "$MALICIOUS_DIR/$filename"
            rm "$filepath"
        fi
    done
}

if [ ! -f directory-info.last ]; then
    scan_dir
    ls -l "$DIR" > directory-info.last
else
    ls -l "$DIR" > directory-info.new
    if ! cmp -s directory-info.last directory-info.new; then
        scan_dir
        cp directory-info.new directory-info.last
    fi
fi

