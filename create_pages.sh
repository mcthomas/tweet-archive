#!/bin/bash

cd "$(dirname "$0")"

yes | find . -mindepth 2 -type f -exec mv -i '{}' . \;
yes | find . -mindepth 1 -maxdepth 1 -type d -exec rm -r '{}' \;

dir_counter=1

    all_latest_files=()
    while IFS= read -r file; do
        all_latest_files+=("$file")
    done < <(grep -rl '"created_at":' *.json | xargs -I{} stat --format="%Y %n" {} | sort -nr | cut -d' ' -f2-)

while (( ${#all_latest_files[@]} > 0 )); do

    latest_files=("${all_latest_files[@]:0:30}")
    all_latest_files=("${all_latest_files[@]:30}")
    
    if [ -z "$latest_files[@]" ]; then
        echo "No JSON files found."
        break
    fi

oldest_timestamp=""
for file in "${latest_files[@]}"; do
    created_at=$(grep -Eo '"created_at": "[^"]+"' "$file" | cut -d'"' -f4)
    timestamp=$(date -d "$(echo "$created_at" | sed 's/\(..\) \([a-zA-Z]\{3\}\) /\1 \2 /')" "+%s")
    if [ -z "$oldest_timestamp" ] || [ "$timestamp" -lt "$oldest_timestamp" ]; then
        oldest_timestamp="$timestamp"
    fi
done

oldest_date=$(date -d "@$oldest_timestamp" "+%a %b %d %T %z %Y")

    formatted_date=$(echo "$oldest_date" | awk '{
    split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", months, " ");
    for (i=1; i<=12; i++) {
        if ($2 == months[i]) {
            month_number = sprintf("%02d", i);
            break;
        }
    }
    print $6"-"month_number"-"$3"_⇡"
    }')

    new_dir="$formatted_date"
    mkdir "$new_dir"

    mv ${latest_files[@]} "$new_dir"
    cp page_index.html "$new_dir"/index.html
    cd "$new_dir"
    ls *.json > listOfFiles.txt
    sed -i -e 's/\.json//g' listOfFiles.txt
    cd ..

    for json_file in ${latest_files[@]}; do
        json_base_name=$(basename "$json_file" .json)
        for file in "$json_base_name"*; do
            if [ -f "$file" ]; then
                mv "$file" "$new_dir"
            fi
        done
    done

    echo "Files moved to directory: $new_dir"

    ((dir_counter++))
done

bash gen_index.sh
