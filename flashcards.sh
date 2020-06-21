#!/usr/bin/bash

SEP=';'
MODE='F'
READ='F'
CAMO='F'
HELP='F'
WP='F'
PROV='F'
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

if [[ ${FILES[@]} == '[]' && $HELP == 'F' && $WP == 'F' ]]; then
  PROV='T'
  echo -e "\e[31mNo data provided.\e[0m\e[34m Provide data now:\e[0m"
  FILES=($(cat - | xargs -i echo {}))
  # cat - | xargs -i echo {} | xargs
  echo -en "\e[0m"
fi

# echo "-------"
# echo ${FILES[@]}

if [[ $WP == 'T' && $HELP == 'F' ]]; then
  echo -e "\e[31mWrong parameter.\e[34m Try again or use help flag ('-h'/'--help') for more information.\e[0m"
elif [[ ${FILES[@]} != '[]' && $HELP == 'F' ]]; then

  if [[ $PROV == 'T' ]]; then
    if [[ $MODE == 'F' ]]; then
      FOREIGN=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
      NATIVE=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
    else
      NATIVE=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
      FOREIGN=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
    fi
  else
    if [[ $MODE == 'F' ]]; then
      FOREIGN=($(cat ${FILES[@]} | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
      NATIVE=($(cat ${FILES[@]} | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
    else
      NATIVE=($(cat ${FILES[@]} | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
      FOREIGN=($(cat ${FILES[@]} | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
    fi
  fi

  echo -e "\e[33;1m${#FOREIGN[@]}\e[0m\e[34m words added\e[0m"

  while [[ $ff < ${#FOREIGN[@]} ]] ; do

    if [[ $READ == 'T' ]]; then
        espeak "${NATIVE[$ff]}"
    fi

    if [[ $CAMO == 'F' ]]; then
      echo -en "${NATIVE[$ff]} - \e[0m"
    fi

    read -r temp
    if [[ $temp == ${FOREIGN[$ff]} ]] ; then
      SCORE=$(($SCORE + 1))
    else
      echo -e "\e[31mWrong answear \e[1m:(\e[0m\e[34m Should be \e[36;1m${FOREIGN[$ff]}\e[0m"
      FAILS=$(($FAILS + 1))
    fi

    # echo $ff
    ff=$(($ff + 1))

  done

  echo -e "\e[34mYour score:\e[0m\e[33;1m $SCORE\e[0m"
  echo -e "\e[34mYour fails:\e[0m\e[33;1m $FAILS\e[0m"
  echo -e "\e[34mPercentage of correct answears:\e[0m\e[33;1m $(echo "scale=2;($SCORE / ($SCORE + $FAILS)) * 100" | bc ) %\e[0m"

fi
# echo "SCRIPT TESTING:"
# echo "---------------"
# echo "Current SEP:    $SEP"
# echo "Current MODE:   $MODE"
# echo "Current READ:   $READ"
# echo "Current CAMO:   $CAMO"
# echo "Current items:  $items"
# echo "Current HELP:   $HELP"
# echo "Current FILES:  ${FILES[*]} ${#FILES[*]}"
