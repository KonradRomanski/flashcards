#!/usr/bin/bash

SEP=';'
ORD='N'
MODE='F'
READ='F'
CAMO='F'
HELP='F'
WP='F'
PROV='F'
FILES=[]
items=0
shi=0
LAN="en pl"

NATIVE=[]
FOREIGN=[]
SCORE=0
FAILS=0
PERCENTAGE=0

function help
{
  echo "Welcome to help!"
  echo "Usage (when script in actuall directory): ./flashcards [OPTION] [OPTION ARGUMENT]"
  echo
  echo "List of avaible arguments:"
  echo
  echo "  -h, --help        to show this informations"
  echo "  -f, --file        to read data from files"
  echo "  -s, --separator   to change the separator (by default is ';') It cannot be ' '!"
  echo "  -m, --mode        to change the learning mode - words in the foreign language are shown first (by default the native language is first)"
  echo "  -r, --read        to pronounce the word. Language must be specified. Use 'h'/'help' option to see avaible options."
  echo "  -c, --camouflage  to hide the word"
  echo "  -o, --order       to change words order, avaible options:"
  echo "                     'O'/'o' - original order (default)"
  echo "                     'R'/'r' - random order"
  echo "                     'A' - ascending order of foreign words"
  echo "                     'a' - ascending order of native words"
  echo "                     'D' - descending order of foreign words"
  echo "                     'd' - descending order of native words"
  echo
  echo "Template for every data line: [word in foreign language][separator][word in native language]"
  echo "Commands examples:"
  echo
  echo "./flashcards.sh --readh                                         - help for read argument"
  echo "./flashcards.sh -f words2 -s '-' -or                            - words2 as input data, '-' as separator, random order"
  echo "./flashcards.sh -f words1 -r 'pl' -s '-'                        - words1 as input data, '-' as separator, reading words in polish (pl)"
  echo "./flashcards.sh -f words3 -r 'en' -s '-' -m                     - words3 as input data, '-' as separator, reading words in english (en), word in foregin language first"
  echo "./flashcards.sh --file words1 --separator'-' -mr'en' -oA        - words1 as input data, '-' as separator, reading words in english (en), word in foregin language first, ascending order of foreign words"
}

function usage
{
  echo -e "\e[31mWrong parameter\e[33;1m $1\e[0m\e[34m Try again or use help flag ('-h'/'--help') for more information.\e[0m"
}

set -- $(echo $@ | sed "s/--help/-h/g")
set -- $(echo $@ | sed "s/--file/-f/g")
set -- $(echo $@ | sed "s/--separator/-s/g")
set -- $(echo $@ | sed "s/--mode/-m/g")
set -- $(echo $@ | sed "s/--read/-r/g")
set -- $(echo $@ | sed "s/--camouflage/-c/g")
set -- $(echo $@ | sed "s/--order/-o/g")

for argument in "$@"; do
    if [[ $argument == "--"* ]]; then
        usage ${argument}
        exit
      fi
done


while getopts ":hf:s:mr:co:" opt; do
  case $opt in
    h) help; exit;;
    f)

    FILES=${OPTARG}
    until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z $(eval "echo \${$OPTIND}") ]; do
       FILES+=($(eval "echo \${$OPTIND}"))
       OPTIND=$((OPTIND + 1))
    done

    ;;
    s) SEP=${OPTARG};;
    m) MODE='T';;
    r)
    LAN=${OPTARG}
    READ='T'
    ;;
    c) CAMO='T';;
    o) ORD=${OPTARG};;
    :)
    echo -e "\e[31mERROR:\e[33;1m -${OPTARG}\e[0m\e[34m requires an argument.\e[0m"
    exit
    ;;
    *)
    usage "-${OPTARG}"
    exit
    ;;
  esac
done


if [[ $LAN == 'h' || $LAN == 'help' ]]; then
  echo "List of avaible languages:"
  espeak --voice
  exit
fi

if [[ $(echo $LAN | tr -cd ' ') == '' ]]; then
  if [[ $MODE == 'F' ]];then
    LAN1=$LAN
    LAN2='en'
  else
    LAN1=pl
    LAN2=$LAN
  fi
else
LAN1=$(echo $LAN | cut -d ' ' -f1)
LAN2=$(echo $LAN | cut -d ' ' -f2)
fi


if [[ ${FILES[@]} == '[]' && $HELP == 'F' && $WP == 'F' ]]; then
  PROV='T'
  echo -e "\e[31mNo data provided.\e[0m\e[34m"
  echo "Template: [word in a foreign language][separator][word in a native language]"
  echo -e "Provide data now:\e[0m"
  FILES=($(cat - | xargs))
  echo -en "\e[0m"
elif [[ $HELP == 'F' ]]; then
  FILES=($(cat ${FILES[@]} | xargs))
fi

if [[ $(echo ${FILES[0]} | tr -cd $SEP) != $SEP ]];then
  echo -e "\e[31mWrong separator\e[34m Try again or use help flag ('-h'/'--help') for more information.\e[0m"
  exit
fi

case $ORD in
  R|r) FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -R | xargs)) ;;
  A)   FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -k1 | xargs)) ;;
  a)   FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -k2 | xargs)) ;;
  D)   FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -rk1 | xargs)) ;;
  d)   FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -rk2 | xargs)) ;;
esac


if [[ $WP == 'T' && $HELP == 'F' ]]; then
  usage;exit
elif [[ ${FILES[@]} != '[]' && $HELP == 'F' ]]; then


  if [[ $MODE == 'F' ]]; then
    NATIVE=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
    FOREIGN=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
  else
    FOREIGN=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
    NATIVE=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
  fi

  echo -e "\e[33;1m${#FOREIGN[@]}\e[0m\e[34m words added\e[0m"
  ff=0
  while  (( $ff < ${#FILES[@]} )) ; do

    if [[ $CAMO == 'F' ]]; then
      echo -en "${NATIVE[$ff]} - \e[0m"
    fi

    if [[ $READ == 'T' ]]; then
      if [[ $MODE == 'F' ]]; then
        espeak -v $LAN1 "${NATIVE[$ff]}"
      else
        espeak -v $LAN2 "${NATIVE[$ff]}"
      fi
    fi

    read -r temp

    if [[ $temp == ${FOREIGN[$ff]} ]] ; then
      SCORE=$(($SCORE + 1))
      echo -e "\e[32mGreat answear\e[0m"
    else
      echo -e "\e[31mWrong answear \e[1m:(\e[0m\e[34m Should be \e[36;1m${FOREIGN[$ff]}\e[0m"
      FAILS=$(($FAILS + 1))
    fi

    # echo $ff
    ff=$(($ff + 1))

  done
  PERCENTAGE=$(echo "scale=3;($SCORE / ($SCORE + $FAILS)) * 100" | bc )

  echo -e "\e[34mYour score:\e[0m\e[33;1m $SCORE / $(($SCORE + $FAILS))\e[0m"
  echo -e "\e[34mYour fails:\e[0m\e[33;1m $FAILS / $(($SCORE + $FAILS))\e[0m"
  echo -e "\e[34mPercentage of correct answears:\e[0m\e[33;1m $PERCENTAGE %\e[0m"

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
# echo "Current NATIVE  ${NATIVE[@]} ${#NATIVE[@]}"
# echo "Current FOREIGN ${FOREIGN[@]} ${#FOREIGN[@]}"
# echo "Current LAN     _${LAN[@]}_  _$LAN1 _ _$LAN2 _"
