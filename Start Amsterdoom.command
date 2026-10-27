#!/bin/bash
# Mac: serves this folder on http://127.0.0.1 (only for this computer) and opens Amsterdoom in
# the browser, with the Perl that macOS includes (no installation needed). Close this Terminal
# window, or press Ctrl+C, to stop.
cd "$(dirname "$0")" || exit 1
exec /usr/bin/perl serve.pl
