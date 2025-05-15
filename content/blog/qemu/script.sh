#!/bin/bash

# Recursively convert YAML front matter to Org mode properties in all .org files

find . -type f -name "*.org" -print0 | while IFS= read -r -d '' file; do
    # Process each file
    awk '
    BEGIN { in_yaml = 0; first_property = 1 }
    /^---$/ {
        if (in_yaml == 0) {
            in_yaml = 1
            next
        } else {
            in_yaml = 0
            # Print blank line after properties if needed
            if (!first_property) print ""
            next
        }
    }
    in_yaml == 1 {
        if (first_property) {
            print "#+PROPERTY:"
            first_property = 0
        }
       if ( $1 == "date:") {
            sub(/date: /, "#+DATE: ")
        }
        elseif ( $1 == "draft:") {
            sub(/draft: /, "#+DRAFT: ")
        }
        elseif ( $1 == "title:") {
            sub(/title: /, "#+TITLE: ")
        }
        else {
            # Convert other YAML fields to Org properties
            sub(/: /, ": ")
            /bin/bash = "#+" toupper() substr(/bin/bash, length()+1)
        }
        # Remove trailing whitespace
        sub(/[[:space:]]+$/, "")
        print /bin/bash
        next
    }
    { print }
    ' "" > ".tmp" && mv ".tmp" ""
done

echo "Conversion complete for all Org files"
