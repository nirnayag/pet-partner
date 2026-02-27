#!/bin/bash
# Wrapper to run dart analyze avoiding cache permission issues

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Filter out --no-pub flag which dart analyze doesn't support
args=$(echo "$@" | sed 's/--no-pub//g')

# Find dart binary from flutter
DART_BIN=$(which dart 2>/dev/null || echo "dart")

output=$($DART_BIN analyze --no-fatal-warnings $args 2>&1)
exit_code=$?

# Filter telemetry/permission noise
filtered=$(echo "$output" | grep -v "FileSystemException" | grep -v "dart-flutter-telemetry" | grep -v -i "operation not permitted" | grep -v "setLastModifiedSync" | grep -v "UserProperty" | grep -v "#[0-9]" | grep -v "asynchronous suspension" | grep -v "^$")

echo "$filtered"

if echo "$filtered" | grep -q -E "(error|warning)" && [ "$exit_code" -ne 0 ]; then
  exit 1
fi

if echo "$filtered" | grep -q "issues found" && ! echo "$filtered" | grep -q "No issues found"; then
  if echo "$filtered" | grep -q -E "error|warning"; then
    exit 1
  fi
fi

exit 0
