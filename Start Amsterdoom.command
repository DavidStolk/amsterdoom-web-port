#!/bin/bash
# Serves this folder on http://127.0.0.1 and opens Amsterdoom in the browser.
# Close this Terminal window (or press Ctrl+C) to stop.
cd "$(dirname "$0")"
PORT=8123
while lsof -nP -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1; do PORT=$((PORT + 1)); done
echo "Amsterdoom: http://127.0.0.1:$PORT/  (close this window to stop)"
(sleep 1; open "http://127.0.0.1:$PORT/") &
exec python3 -m http.server $PORT --bind 127.0.0.1
