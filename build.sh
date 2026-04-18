# Clean.
rm -rf output
mkdir output

# Build the codelabs.
find "$(pwd)" -type f -name "codelab.md" | while read file; do
  cd output
  claat export "$file"
  cd ..
done
