#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dir> <malicious_dir>"
    exit 1
fi

dir="$1"
malicious_dir="$2"
whitelist_file=".whitelist"

while true; do
    if [ -z "$(ls -A "$malicious_dir" 2>/dev/null)" ]; then
        echo "No malicious files to review."
        exit 0
    fi
    
    echo "Quarantined files available for review:"
    files=("$malicious_dir"/*)
    for i in "${!files[@]}"; do
        echo "$((i+1)). $(basename "${files[$i]}")"
    done
    
    read -p "Select a file by number (or 0 to exit): " choice
    if [[ "$choice" -eq 0 ]]; then exit 0; fi
    
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt "${#files[@]}" ]]; then
        echo "Invalid selection."
        continue
    fi
    
    idx=$((choice-1))
    selected_path="${files[$idx]}"
    selected_file=$(basename "$selected_path")
    
    echo "1. Restore this file back into dir (it was a false positive)"
    echo "2. Permanently delete this file from malicious_dir (it was genuinely malicious)"
    echo "3. Leave this file as-is and go back to the list"
    
    read -p "Your choice: " action
    
    case $action in
        1)
            mv "$selected_path" "$dir/"
            echo "Restored $selected_file to $dir."
            echo "$selected_file" >> "$whitelist_file"
            ;;
        2)
            rm "$selected_path"
            echo "$selected_file permanently deleted."
            ;;
        3)
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
