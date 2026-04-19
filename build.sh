#!/bin/bash

set -e  # Exit on error

rm -rf output
mkdir output

find "$(pwd)" -type f -name "codelab.md" | while read -r file; do
  filename=$(basename "$(dirname "$file")")
  (cd output && claat export "$file")
done

echo "Build complete - all codelabs exported to output/ directory."

./generate_nav.sh