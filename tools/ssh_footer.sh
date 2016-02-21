echo In ssh_footer.sh
echo tool tog $TOOL_TAG and prefix stub $PREFIX_STUB 
echo check contigs $CONTIGS
if [[ -n "$CONTIGS" ]]; then 
  cp $CONTIGS $SSH_RESULTDIR/${TOOL_TAG}c${PRFIX_STUB}i.fasta; 
fi
echo check scafolds $SCAFFOLDS
if [[ -n "$SCAFFOLDS" ]]; then
  cp $SCAFFOLDS $SSH_RESULTDIR/${TOOL_TAG}s${PRFIX_STUB}i.fasta
fi
echo check metrics $METRICS
if [[ -n "$METRICS" ]]; then
  cp $METRICS $SSH_RESULTDIR/m_${PRFIX_STUB}_${TOOL_TAG}
fi
end=$(date +%s)
runtime=$((end-start))
echo -e "start: $start \tend: $end \ttaken $runtime" >> $LOGFILE
echo `basename "$0"`: FINISHED!! FINISHED!!
echo finish ssh_footer.sh