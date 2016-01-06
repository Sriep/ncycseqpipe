if [[ -n "$CONTIGS" ]]; then 
  cp $CONTIGS $LOCAL_RESULTDIR/${TOOL_TAG}c${PRFIX_STUB}i.fasta; 
fi
if [[ -n "$SCAFFOLDS" ]]; then
  cp $SCAFFOLDS $LOCAL_RESULTDIR/${TOOL_TAG}s${PRFIX_STUB}i.fasta
fi
if [[ -n "$METRICS" ]]; then
  cp $METRICS $LOCAL_RESULTDIR/m_${PRFIX_STUB}_${TOOL_TAG}
fi

end=$(date +%s)
runtime=$((end-start))
echo -e "start: $start \tend: $end \ttaken $runtime" >> $LOGFILE
echo `basename "$0"`: FINISHED!! FINISHED!!
