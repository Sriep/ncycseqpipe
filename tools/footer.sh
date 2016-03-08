end=$(date +%s)
runtime=$((end-start))
echo -e "name\t${TOOL_NAME}\tpreifx\t${PREFIX}\tstart:\t${start}\tend:\t${end}\ttaken\t${runtime}" >> $LOGFILE
