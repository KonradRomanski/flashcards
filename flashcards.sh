#!/usr/bin/bash

SEP=';'
MODE='F'
READ='F'
CAMO='F'
HELP='F'
FILES=[]
items=0
shi=0

NATIVE=[]
FOREIGN=[]
SCORE=0
FAILS=0

for i in "$@"; do
  case $i in
    -h|--help)
    shift
    echo "Welcome to help!"
    echo "Usage (when script in actuall directory): ./flashcards [OPTION]... [FILE]"
    echo
    echo "WARNING! Every argument that is not described below is treated as a file"
    echo
    echo "  -h, --help        to show this informations"
    # echo "  -f, --file        to provide data from files"
    echo "  -s, --separator   to change the separator (by default is ';')"
    echo "  -m, --mode        to change the learning mode  - word in the foreign language  is shown first (by default the native language is first)"
    echo "  -r, --read        to make the word be spoken aloud"
    echo "  -c, --camouflage  to hide the word"
    echo
    echo "Examples: "
    echo "..."
    HELP='T'
    ;;

    -f|--file)
    shift
    ;;

    -s|-s-separator)
    SEP=$2
    shift
    shi=1
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

    *)
    if [[ $shi == 0 ]]; then
      FILES[items]=$1
      echo "*" $items ${FILES[items]} $i
      shift
      items=$(($items + 1))
    else
      SHI=$(($SHI - 1))
      shift
    fi
    ;;

  esac
  echo === -$1  $i
done

if [[ $HELP == 'F' && ${#FILES[*]} == 1 ]]; then
  echo "No data prvided. Try again or use help flag ('-h'/'--help') for more information."
# else

fi

echo "SCRIPT TESTING:"
echo "---------------"
echo "Current SEP:    $SEP"
echo "Current MODE:   $MODE"
echo "Current READ:   $READ"
echo "Current CAMO:   $CAMO"
echo "Current items:  $items"
echo "Current HELP:   $HELP"
echo "Current FILES:  ${FILES[*]} ${#FILES[*]}"
