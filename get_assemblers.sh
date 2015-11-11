#!/bin/bash
declare -ax ASSEMBLER_NAME
declare -ax ASSEMBLER_LOCATION
declare -ax ASSEMBLER_TAG
declare -ax ASSEMBLER_PARAMTERS
declare -xi NUM_ASSMEBLERS=0

if [[ -n "ASSEMBLERS_FILE" ]]; then
  while read col1 col2 col3 col4; do 
    echo -e "Assembler $col1 \tlocation $col2 \ttag $col3 \tparamter $col4"
    NUM_ASSMEBLERS=$(($NUM_ASSMEBLERS + 1 ))
    echo "num of assemblers $NUM_ASSMEBLERS"
    ASSEMBLER_NAME[NUM_ASSMEBLERS]=$col1
    ASSEMBLER_LOCATION[NUM_ASSMEBLERS]=$col2
    ASSEMBLER_TAG[NUM_ASSMEBLERS]=$col3
    #Sorry about next line cut and pasted from internet
    declare params_quotes_striped=$(echo "$col4" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
    ASSEMBLER_PARAMTERS[NUM_ASSMEBLERS]=$params_quotes_striped
    
    
    echo and again
    echo -e "Assembler ${ASSEMBLER_NAME[$NUM_ASSMEBLERS]} \tlocation ${ASSEMBLER_LOCATION[$NUM_ASSMEBLERS]} \ttag ${ASSEMBLER_TAG[$NUM_ASSMEBLERS]}\tparamter ${ASSEMBLER_PARAMTERS[$NUM_ASSMEBLERS]}"
  done < $ASSEMBLERS_FILE
fi

echo "all: number of assemblers $NUM_ASSMEBLERS"
echo all: show assembly array
echo "num of assemblers is $NUM_ASSMEBLERS"
for (( i=1; i<=$NUM_ASSMEBLERS; i++ )); do
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
readonly NUM_ASSMEBLERS