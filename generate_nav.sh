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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://fonts.googleapis.com/css?family=Poppins:400,500,600&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Poppins', 'Roboto', 'Segoe UI', Arial, sans-serif;
      margin: 0;
      background: #191919;
      color: #f7f6f3;
    }
    .header {
      background: #222327;
      color: #f7f6f3;
      padding: 0;
      margin: 0 0 40px 0;
      width: 100%;
      box-shadow: 0 2px 8px rgba(15,23,42,0.10);
      display: flex;
      align-items: center;
      height: 64px;
      border-bottom: 1px solid #28282b;
    }
    .header .title {
      font-size: 1.5em;
      font-weight: 600;
      letter-spacing: 0.5px;
      margin: 0 0 0 32px;
      flex: 1;
      text-align: left;
      line-height: 64px;
      display: inline-block;
    }
    .header .subtitle {
      font-size: 1em;
      opacity: 0.7;
      margin-right: 32px;
      color: #b0b0b0;
      display: inline-block;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
      padding: 0 24px;
    }
    .module {
      background: #222327;
      border-radius: 8px;
      border: 1px solid #28282b;
      box-shadow: 0 1.5px 6px rgba(15,23,42,0.10);
      margin-bottom: 28px;
      padding: 24px 24px 12px 24px;
      transition: box-shadow 0.2s, border 0.2s;
    }
    .module:hover {
      box-shadow: 0 4px 16px rgba(108,180,255,0.10);
      border: 1px solid #338eda;
    }
    .module h2 {
      margin-top: 0;
      color: #f7f6f3;
      font-size: 1.2em;
      margin-bottom: 12px;
      font-weight: 600;
    }
    .submodule {
      margin-left: 0;
      margin-bottom: 10px;
      padding: 10px 0 10px 12px;
      border-left: 3px solid #28282b;
      background: #23242a;
      border-radius: 4px;
      transition: background 0.2s, border 0.2s;
    }
    .submodule:hover {
      background: #232b36;
      border-left: 3px solid #338eda;
    }
    a {
      text-decoration: none;
      color: #6cb4ff;
      font-weight: 500;
      font-size: 1.08em;
      transition: color 0.2s;
    }
    a:hover {
      color: #338eda;
      text-decoration: underline;
    }
    @media (max-width: 600px) {
      .container { padding: 0 14px; }
      .module { padding: 14px 12px 10px 12px; }
      .submodule { padding-left: 18px; padding-right: 8px; }
      .header .title { font-size: 1.1em; }
    }
  </style>
</head>
<body>
  <div class="header">
    <span class="title">$project_display</span>
  </div>
  <div class="container">
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
  </div>
</body>
</html>
EOF
    fi
  fi
done