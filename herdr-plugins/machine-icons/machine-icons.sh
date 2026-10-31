#!/bin/sh
# Prefix every saved SSH machine label with the server icon (nf-md-server_network).
# Machines that already have it are left alone, so this is safe to run repeatedly.
set -u

ICON=$(printf '\363\260\222\215')   # U+F048D as UTF-8 bytes (POSIX printf has no \U)

herdr machine list | while IFS="$(printf '\t')" read -r id label _; do
  [ -n "$id" ] || continue
  case "$label" in
    "$ICON"*) ;;
    *) herdr machine rename "$id" --label "$ICON $label" ;;
  esac
done
