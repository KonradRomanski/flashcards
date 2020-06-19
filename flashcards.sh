#!/usr/bin/env bash

SEP=';'
for i in "$@"; do
  case $i in
    -h);&
    --help)
    echo "Welcome to help!"
    echo "Usage (when script in actuall directory): ./flashcards [OPTION]... [FILE]"
    echo
    echo "  -h, --help       to show this informations"
    echo "  -s, --separator  to change the separator (by default is ';')"
    echo "  -f, --foreign    to change the learning mode  - word in the foreign language  is shown first (by default the native language is first)"
    echo "  -s, --say        to make the word be spoken aloud"
    echo "  -h, --hide       to hide the word"
    echo
    echo "Examples: "
    echo "..."
    ;;

    -s);&
    --separator)
      shift
      SEP=$i
    ;;
  esac
done
echo $SEP
