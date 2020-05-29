#!/usr/bin/env bash

SEP=';'
for i in "$@"; do
  case $i in
    -h);&
    --help)
    echo "Welcome to help!"
    echo "Usage: ./flashcards [OPTION]... [FILE]"
    echo
    echo "  -h, --help       to show this informations"
    echo "  -s, --separator  to change default (';') separator"
    ;;

    -s);&
    --separator)
      shift
      SEP=$i
    ;;
  esac
done
echo $SEP
