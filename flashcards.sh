#!/usr/bin/bash

SEP=';'
MODE='F'
READ='F'
CAMO='F'
HELP='F'
WP='F'
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

    -?*)
    shift
    WP='T'
    ;;

    *)
    if [[ $shi == 0 ]]; then
      FILES[items]=$1
      # echo "*" $items ${FILES[items]} $i
      shift
      items=$(($items + 1))
    else
      shi=$(($shi - 1))
      shift
    fi
    ;;

  esac
  # echo === -$1  $i
done
if [[ $WP == 'T' ]]; then
  echo "Wrong parameter.Try again or use help flag ('-h'/'--help') for more information."
elif [[ $HELP == 'F' && ${FILES[@]} == '[]' ]]; then
  echo "No data prvided. Try again or use help flag ('-h'/'--help') for more information."
else
  FOREIGN=($(cat ${FILES[@]} | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
  NATIVE=($(cat ${FILES[@]} | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
  # echo
  echo ${FOREIGN[*]}
  # echo ${NATIVE[*]}
 echo ${#FOREIGN[@]}

  while [[ $ff < ${#FOREIGN[@]} ]] ; do

    echo -n "${NATIVE[$ff]} - "

    read -r temp
    if [[ $temp == ${FOREIGN[$ff]} ]] ; then
      SCORE=$(($SCORE + 1))
    else
      FAILS=$(($FAILS + 1))
    fi

    # echo $ff
    ff=$(($ff + 1))

  done
fi

  echo "Your score: $SCORE"
  echo "Your fails: $FAILS"
  # echo "Percentage of correct answears: " $(( $(( $SCORE / $(( $SCORE + $FAILS )) )) * 100 ))
  # echo "Percentage of correct answears: "   $(echo "scale=4;1/$FAILS" | bc )
  echo "Percentage of correct answears: " $(echo "scale=2;($SCORE / ($SCORE + $FAILS)) * 100" | bc ) "%"

# echo "SCRIPT TESTING:"
# echo "---------------"
# echo "Current SEP:    $SEP"
# echo "Current MODE:   $MODE"
# echo "Current READ:   $READ"
# echo "Current CAMO:   $CAMO"
# echo "Current items:  $items"
# echo "Current HELP:   $HELP"
# echo "Current FILES:  ${FILES[*]} ${#FILES[*]}"
