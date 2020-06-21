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
  echo "Usage (when script in actuall directory): ./flashcards [OPTION]... [FILE]"
  echo
  echo "WARNING! Every argument that is not described below is treated as a file"
  echo
  echo "  -h, --help        to show this informations"
  echo "  -f, --file        to read data from files"
  echo "  -s, --separator   to change the separator (by default is ';') It cannot be ' '!"
  echo "  -m, --mode        to change the learning mode - words in the foreign language is shown first (by default the native language is first)"
  echo "  -r, --read        to make the word be spoken aloud. default are english and polish. Others can be specified. Use 'h'/'help' option to see avaible options."
  echo "  -c, --camouflage  to hide the word"
  echo "  -o, --order       to change words order, avaible options:"
  echo "                    'O'/'o' - original order (default)"
  echo "                    'R'/'r' - random order"
  echo "                    'A' - ascending order of foreign words"
  echo "                    'a' - ascending order of native words"
  echo "                    'D' - descending order of foreign words"
  echo "                    'd' - descending order of native words"
  echo
  echo "Template for every data line: [word in foreign language][separator][word in native language]"
  echo "Examples: "
  echo "..."
}

function usage
{
  echo -e "\e[31mWrong parameter.\e[34m Try again or use help flag ('-h'/'--help') for more information.\e[0m"
}


for argument in "$@"; do
  case "$argument" in
    "--help")       set -- "$@" "-h" ;;
    "--file")       set -- "$@" "-f" ;;
    "--separator")  set -- "$@" "-s" ;;
    "--mode")       set -- "$@" "-m" ;;
    "--read")       set -- "$@" "-r" ;;
    "--camouflage") set -- "$@" "-c" ;;
    "--order")      set -- "$@" "-o" ;;
    "--"*)          usage; exit ;;
  esac
done

# OPTIND=1
while getopts ":hf:s:mr:co:" opt; do
  case $opt in
    h) help; exit;;
    f)
    # echo "opt" $OPTIND

    FILES=${OPTARG}
    until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z $(eval "echo \${$OPTIND}") ]; do
       FILES+=($(eval "echo \${$OPTIND}"))
       OPTIND=$((OPTIND + 1))
    done
    # OPTIND=$((OPTIND - 1))
    # echo "opt" $OPTIND

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
    echo "ERROR: ${OPTARG} requires an argument."
    exit
    ;;
    *)
    echo "ERROR: ${OPTARG} wrong parameter"
    exit
    ;;
  esac
  # echo === -$1  $i
done
echo "F:" ${FILES[@]}
# shift $(expr $OPTIND - 1)p

# for i in "$@"; do
#   case $i in
#     -h)
#     shift
#     help
#     HELP='T'
#     ;;
#
#     -s|--separator)
#     SEP=$2
#     shift
#     shi=$(($shi + 1))
#     ;;
#
#     -m|--mode)
#     shift
#     MODE='T'
#     ;;
#
#     -r|--read)
#     if [[ $2 != -*  && $2 != '' ]]; then
#       LAN1=$2
#       shi=$(($shi + 1))
#       if [[ $3 != -* && $3 != '' ]]; then
#         LAN2=$3
#         shi=$(($shi + 1))
#       fi
#     fi
#     shift
#     READ='T'
#     ;;
#
#     -c|--camouflage)
#     shift
#     CAMO='T'
#     ;;
#
#     -o|--order)
#     ORD=$2
#     shift
#     shi=$(($shi + 1))
#     ;;
#
#     -?*)
#
#     shift
#     WP='T'
#     ;;
#
#     *)
#     if [[ $shi == 0 ]]; then
#       FILES[items]=$1
#       # echo "*" $items ${FILES[items]} $i
#       shift
#       items=$(($items + 1))
#     else
#       shi=$(($shi - 1))
#       shift
#     fi
#     ;;
#
#   esac
#   # echo === -$1  $i
# done

if [[ $LAN == 'h' || $LAN == 'help' ]]; then
  echo "List of avaible languages:"
  espeak --voice
  exit
fi

if [[ $(echo $LAN | cut -d ' ' -f1) == $(echo $LAN | cut -d ' ' -f2) ]]; then
LAN1='pl'
LAN2='en'
else
LAN1=$(echo $LAN | cut -d ' ' -f1)
LAN2=$(echo $LAN | cut -d ' ' -f2)
fi

if [[ ${FILES[@]} == '[]' && $HELP == 'F' && $WP == 'F' ]]; then
  PROV='T'
  echo -e "\e[31mNo data provided.\e[0m\e[34m"
  echo "Template: [word in foreign language][separator][word in native language]"
  echo -e "Provide data now:\e[0m"
  FILES=($(cat - | xargs))
  # cat - | xargs -i echo {} | xargs
  echo -en "\e[0m"
elif [[ $HELP == 'F' ]]; then
  FILES=($(cat ${FILES[@]} | xargs))
fi

# # if [[ $ORD == 'R' || $ORD == 'r' ]]; then
# if [[ $ORD == 'A' ]]; then
#   echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -k2
# fi

case $ORD in
  R|r)
  FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -R | xargs))
  ;;
  A)
  FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -k1 | xargs))
  ;;
  a)
  FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -k2 | xargs))
  ;;
  D)
  FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -rk1 | xargs))
  ;;
  d)
  FILES=($(echo ${FILES[@]} | tr ' ' '\n' | sort -t $SEP -rk2 | xargs))
  ;;
esac

# echo "-------"
# echo ${FILES[@]}


if [[ $WP == 'T' && $HELP == 'F' ]]; then
  usage;exit
elif [[ ${FILES[@]} != '[]' && $HELP == 'F' ]]; then


  if [[ $MODE == 'F' ]]; then
    FOREIGN=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
    NATIVE=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
  else
    NATIVE=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f1 | tr '\n' ' ' | rev | cut -c2- | rev))
    FOREIGN=($(echo ${FILES[@]} | tr ' ' '\n' | cut -d $SEP -f2 | tr '\n' ' ' | rev | cut -c2- | rev))
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
    else
      echo -e "\e[31mWrong answear \e[1m:(\e[0m\e[34m Should be \e[36;1m${FOREIGN[$ff]}\e[0m"
      FAILS=$(($FAILS + 1))
    fi

    # echo $ff
    ff=$(($ff + 1))

  done
  PERCENTAGE=$(echo "scale=2;($SCORE / ($SCORE + $FAILS)) * 100" | bc )

  echo -e "\e[34mYour score:\e[0m\e[33;1m $SCORE\e[0m"
  echo -e "\e[34mYour fails:\e[0m\e[33;1m $FAILS\e[0m"
  echo -e "\e[34mPercentage of correct answears:\e[0m\e[33;1m $PERCENTAGE %\e[0m"

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
echo "Current NATIVE  ${NATIVE[@]} ${#NATIVE[@]}"
echo "Current FOREIGN ${FOREIGN[@]} ${#FOREIGN[@]}"
echo "Current LAN     _${LAN[@]}_  _$LAN1 _ _$LAN2 _"
