#!/bin/bash

#TO RUN THIS TEST DO WITHOUT '#':
#./test_coverage.sh

# Fail on error
set -e

# Run flutter tests with coverage
echo "Running flutter tests with coverage..."
flutter test --coverage

# Check if lcov is installed
echo "Checking for lcov..."
if ! command -v genhtml &> /dev/null; then
  echo "lcov/genhtml not found. Installing lcov..."
  sudo apt-get update && sudo apt-get install -y lcov
else
  echo "lcov already installed."
fi

# Remove repository files from coverage
lcov --remove coverage/lcov.info 'lib/app/repositories/*' -o coverage/lcov.info

# Generate HTML report
echo "Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

# Open the report in the default browser
echo "Opening HTML report..."
xdg-open coverage/html/index.html &

echo "Done!"
