#!/bin/bash

# Print help message
print_help() {
    echo "Usage: $0 [options] search_string filename"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match"
    echo "  --help  Show this help message"
    exit 0
}

# Check if no arguments
if [ "$#" -lt 2 ]; then
    echo "Error: Not enough arguments."
    print_help
    exit 1
fi

# Initialize flags
show_line_numbers=false
invert_match=false

# Parse options manually
while [[ "$1" == -* ]]; do
    case "$1" in
        -n) show_line_numbers=true ;;
        -v) invert_match=true ;;
        -vn|-nv)
            show_line_numbers=true
            invert_match=true
            ;;
        --help)
            print_help
            ;;
        *)
            echo "Error: Unknown option $1"
            print_help
            ;;
    esac
    shift
done

# Now first argument is search string
search_string="$1"
shift

# Next argument is filename
file="$1"

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Read the file line by line
line_number=0
while IFS= read -r line; do
    ((line_number++))
    
    # Check if line matches search string (case-insensitive)
    if echo "$line" | grep -i -q "$search_string"; then
        match=true
    else
        match=false
    fi

    # Handle invert match
    if $invert_match; then
        match=! $match
    fi

    if $match; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"