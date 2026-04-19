#!/bin/bash

# Function to convert kebab-case or snake_case to Title Case, preserving all-uppercase words
function to_title_case() {
  echo "$1" | awk -F'[-_]' '{
    for (i=1; i<=NF; i++) {
      if ($i ~ /^[A-Z0-9]+$/) {
        $i = $i
      } else {
        $i = toupper(substr($i,1,1)) tolower(substr($i,2))
      }
    }
    print $0
  }' OFS=' '
}

# Find all projects
for project_dir in */; do
  if [ -d "$project_dir" ] && [ "$project_dir" != "output/" ]; then
    project=$(basename "$project_dir")
    project_display=$(to_title_case "$project")
    # Check if has codelab.md
    if find "$project_dir" -name "codelab.md" | grep -q .; then
      # Generate HTML for this project
      html_file="output/${project}.html"
      echo "Generating $html_file"
      # Start HTML
      cat > "$html_file" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>$project_display</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .module { margin-bottom: 20px; }
    .submodule { margin-left: 20px; }
    a { text-decoration: none; color: blue; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <h1>$project_display</h1>
EOF
      # Find modules
      for module_dir in "$project_dir"*/; do
        if [ -d "$module_dir" ]; then
          module=$(basename "$module_dir")
          module_display=$(to_title_case "$module")
          # Check if has codelab.md
          if find "$module_dir" -name "codelab.md" | grep -q .; then
            echo "<div class='module'>" >> "$html_file"
            echo "<h2>$module_display</h2>" >> "$html_file"
            # Find submodules or direct codelab
            for sub_dir in "$module_dir"*/; do
              if [ -d "$sub_dir" ] && [ -f "$sub_dir/codelab.md" ]; then
                submodule=$(basename "$sub_dir")
                submodule_display=$(to_title_case "$submodule")
                # Get id and title
                id=$(grep '^id:' "$sub_dir/codelab.md" | sed 's/id: //')
                title=$(grep '^# ' "$sub_dir/codelab.md" | head -1 | sed 's/# //')
                echo "<div class='submodule'>" >> "$html_file"
                echo "<a href='$id/index.html'>$title</a>" >> "$html_file"
                echo "</div>" >> "$html_file"
              fi
            done
            # If no subdirs, check if codelab.md directly in module
            if [ -f "$module_dir/codelab.md" ] && ! find "$module_dir" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
              id=$(grep '^id:' "$module_dir/codelab.md" | sed 's/id: //')
              title=$(grep '^# ' "$module_dir/codelab.md" | head -1 | sed 's/# //')
              echo "<div class='submodule'>" >> "$html_file"
              echo "<a href='$id/index.html'>$title</a>" >> "$html_file"
              echo "</div>" >> "$html_file"
            fi
            echo "</div>" >> "$html_file"
          fi
        fi
      done
      # End HTML
      cat >> "$html_file" <<EOF
</body>
</html>
EOF
    fi
  fi
done