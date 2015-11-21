#!/bin/bash
#declare ASSEMBLERS_FILE=$1
declare -ax ASSEMBLER_NAME
declare -ax ASSEMBLER_LOCATION
declare -ax ASSEMBLER_TAG
declare -ax ASSEMBLER_PARAMTERS
declare -xi NUM_ASSEMBLERS=0

#declare ASSEMBLERS_FILE=$LOOPE_FILE
echo "!!!!!!Temporty loop file assemblers file $ASSEMBLERS_FILE"

if [[ -n "ASSEMBLERS_FILE" ]]; then
  while read col1 col2 col3 col4; do 
    echo -e "Assembler $col1 \tlocation $col2 \ttag $col3 \tparamter $col4"
    NUM_ASSEMBLERS=$(($NUM_ASSEMBLERS + 1 ))
    echo "num of assemblers $NUM_ASSEMBLERS"
    ASSEMBLER_NAME[NUM_ASSEMBLERS]=$col1
    ASSEMBLER_LOCATION[NUM_ASSEMBLERS]=$col2
    ASSEMBLER_TAG[NUM_ASSEMBLERS]=$col3
    #Sorry about next line cut and pasted from internet
    #declare params_quotes_striped=$(echo "$col4" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
    #ASSEMBLER_PARAMTERS[NUM_ASSEMBLERS]=$params_quotes_striped
    ASSEMBLER_PARAMTERS[NUM_ASSEMBLERS]=$col4
    
    echo and again
    echo -e "Assembler ${ASSEMBLER_NAME[$NUM_ASSEMBLERS]} \tlocation ${ASSEMBLER_LOCATION[$NUM_ASSEMBLERS]} \ttag ${ASSEMBLER_TAG[$NUM_ASSEMBLERS]}\tparamter ${ASSEMBLER_PARAMTERS[$NUM_ASSEMBLERS]}"
  done < $ASSEMBLERS_FILE
fi

echo "all: number of assemblers $NUM_ASSEMBLERS"
echo all: show assembly array
echo "num of assemblers is $NUM_ASSEMBLERS"
for (( i=1; i<=$NUM_ASSEMBLERS; i++ )); do
    echo "i = $i"
    echo "tname ${ASSEMBLER_NAME[$i]}"
    echo -en "\tlocation ${ASSEMBLER_LOCATION[$i]}"
    echo -en "\ttag ${ASSEMBLER_TAG[$i]}"
    echo -e "\tparameters ${ASSEMBLER_PARAMTERS[$i]}"
done
echo all: finsih showing assembly list

readonly ASSEMBLER_NAME
readonly ASSEMBLER_LOCATION
readonly ASSEMBLER_TAG
readonly ASSEMBLER_PARAMTERS
readonly NUM_ASSEMBLERS