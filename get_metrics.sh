#!/bin/bash
declare -ax METRIC_NAME
declare -ax METRIC_LOCATION
declare -ax METRIC_TAG
declare -ax METRIC_PARAMTERS
declare -xi NUM_METRICS=0

if [[ -n "METRICS_FILE" ]]; then
  while read col1 col2 col3 col4; do 
    echo -e "METRIC $col1 \tlocation $col2 \ttag $col3 \tparamter $col4"
    NUM_METRICS=$(($NUM_METRICS + 1 ))
    echo "num of METRICs $NUM_METRICS"
    METRIC_NAME[NUM_METRICS]=$col1
    METRIC_LOCATION[NUM_METRICS]=$col2
    METRIC_TAG[NUM_METRICS]=$col3
    #Sorry about next line cut and pasted from internet
    declare params_quotes_striped=$(echo "$col4" | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
    METRIC_PARAMTERS[NUM_METRICS]=$params_quotes_striped
    
    
    echo and again
    echo -e "METRIC ${METRIC_NAME[$NUM_METRICS]} \tlocation ${METRIC_LOCATION[$NUM_METRICS]} \ttag ${METRIC_TAG[$NUM_METRICS]}\tparamter ${METRIC_PARAMTERS[$NUM_METRICS]}"
  done < $METRICS_FILE
fi

echo "all: number of METRICs $NUM_METRICS"
echo all: show assembly array
echo "num of METRICs is $NUM_METRICS"
for (( i=1; i<=$NUM_METRICS; i++ )); do
    echo "i = $i"
    echo "tname ${METRIC_NAME[$i]}"
    echo -en "\tlocation ${METRIC_LOCATION[$i]}"
    echo -en "\ttag ${METRIC_TAG[$i]}"
    echo -e "\tparameters ${METRIC_PARAMTERS[$i]}"
done
echo all: finsih showing assembly list

readonly METRIC_NAME
readonly METRIC_LOCATION
readonly METRIC_TAG
readonly METRIC_PARAMTERS
readonly NUM_METRICS