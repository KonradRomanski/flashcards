#!/usr/bin/bash

SEP=';'
MODE='F'
READ='F'
CAMO='F'
FILES=[]

for i in "$@"; do
  case $i in
    -h|--help)
    echo "Welcome to help!"
    echo "Usage (when script in actuall directory): ./flashcards [OPTION]... [FILE]"
    echo
    echo "  -h, --help        to show this informations"
    echo "  -f, --file        to provide data from files"
    echo "  -s, --separator   to change the separator (by default is ';')"
    echo "  -m, --mode        to change the learning mode  - word in the foreign language  is shown first (by default the native language is first)"
    echo "  -r, --read        to make the word be spoken aloud"
    echo "  -c, --camouflage  to hide the word"
    echo
    echo "Examples: "
    echo "..."
    ;;

    -f|--file)
    ;;

    -s|--separator)
    SEP=$2
    shift
    ;;

    -m|--mode)
    shift
    MODE='T'
    ;;

    -r|--read)
    shift
    READ='T'
    ;;

    -c|--camouflage)
    shift
    CAMO='T'
    ;;

  esac
done
echo "SCRIPT TESTING:"
echo "---------------"
echo "Current SEP:  $SEP"
echo "Current MODE: $MODE"
echo "Current READ: $READ"
echo "Current CAMO: $CAMO"
