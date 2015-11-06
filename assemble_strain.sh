 #!/bin/bash
# $1 Prefix e.g. NCYC93
# $2 First part of the paired end reads, relative to read directory
# $3 Second part of the paired end reads, relative to read directory
declare -r PREFIX=$1
declare -r READS1=$2
declare -r READS2=$3

#To Do - tempory these should be inhereited
#declare -xr SOURCEDIR=/home/shepperp/datashare/Piers/github/ncycseqpipe
#declare -r INPUTDIR=/home/shepperp/datashare/Piers/github/ncycseqpipeHidden/input
#declare -xr CONFIGFILE=$INPUTDIR/ncycseqpipe.cfg

source $CONFIGFILE
readonly HPC_DATA
readonly LOCAL_DATA
readonly RESULTDIR
readonly DO_LOCAL_ABYSS_ASSEMBLY
readonly DO_SSH_ABYSS_ASSEMBLY
readonly DO_LOCAL_SOAPDENOVO2_ASSEMBLY
readonly DO_SSH_SOAPDENOVO2_ASSEMBLY
readonly DO_WGS
readonly DO_PCACTUS
readonly DO_RAGOUT

declare -i ABYSS_BSUBID

echo $PREFIX: source directory $SOURCEDIR
echo $PREFIX: SSH result path $SSH_RESULTDIR
echo $PREFIX: Read directory $READDIR

function send_local_assemblies ()
{
  echo $PREFIX: ------------------------ Local assemblies --------------------
  echo $PREFIX: ------------------------ Abyss --------------------------------
  if [[ "$DO_LOCAL_ABYSS_ASSEMBLY" = "true" ]]; then 
    echo $PREFIX: start abyss local assembly
    $SOURCEDIR/abyss/run_abyss_local.sh $PREFIX $READS1 $READS2 &
    PID_ABYSS_LOCAL=$!
    echo $PREFIX: Abyss local had pid $PID_ABYSS_LOCAL
  fi
  echo $PREFIX: ------------------------- SOAPdenovo2 --------------------------
  if [[ "$DO_LOCAL_SOAPDENOVO2_ASSEMBLY" = true ]]; then 
    echo $PREFIX: start SOAPdenovo2 local assembly
    $SOURCEDIR/SOAPdenovo2/run_soapdenovo2_local.sh $PREFIX $READS1 $READS2 &
    PID_SOAP_LOCAL=$! 
    echo $PREFIX: SOAPdenovo2 local had pid $PID_SOAP_LOCAL
  fi
  echo $PREFIX: ------------------------------- wgs ------------------------
  if [[ "$DO_WGS" = true ]]; then 
    echo $PREFIX: start wgs assembly
    $SOURCEDIR/wgs-8.3rc2/run_wgs.sh $PREFIX $READS1 $READS2 &
    PID_WGS=$!
    echo $PREFIX: wgs had pid $PID_WGS
  fi
}

function send_ssh_assemblies ()
{
  declare -r SSH_SOURCEDIR=${HPC_DATA}${SOURCEDIR#$LOCAL_DATA}
  declare -xr SSH_CONFIGFILE=${CONFIGFILE#*$LOCAL_DATA}
  declare -r SSH_REPORTDIR=$HPC_DATA/$RESULTDIR/$PREFIX/ssh_out
  mkdir -p $LOCAL_DATA/$RESULTDIR/$PREFIX/ssh_out
  echo $PREFIX: ssh source directory at $SSH_SOURCEDIR
  echo $PREFIX: ssh configure directory at $SSH_CONFIGFILE
  echo $PREFIX: Made ssh reportdir at $SSH_REPORTDIR
  
  declare rtv
  function extract_bsubid_from_rtv ()
  {
    #extract id from Job <131068> is submitted to default queue <NBI-Test128>.
    #DANGER requires name NBI-Test128 stay at 11 characters!!!
    rtv=${rtv:5:-47}
  }
  
  echo $PREFIX: ----------------------- Remote assemblies --------------------
  echo $PREFIX: ----------------------- Abyss --------------------------------
  if [[ "$DO_SSH_ABYSS_ASSEMBLY" = "true" ]]; then 
    echo $PREFIX: start abyss assembly over ssh link to $SSH_USERID@$SSH_ADDR
    rtv=$(  ssh -tt -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR \
            "bsub \
              -outdir $SSH_REPORTDIR \
              $SSH_SOURCEDIR/abyss/run_abyss_ssh.sh \
                  $SSH_CONFIGFILE $PREFIX $READS1 $READS2" \
         )
    echo $PREFIX:  Abyss ssh assembly return value $rtv
    extract_bsubid_from_rtv
    ABYSS_BSUBID=$rtv
    echo $PREFIX: Abyss ssh bsub id is $ABYSS_BSUBID
  fi
  if [ "$DO_SSH_SOAPDENOVO2_ASSEMBLY" = true ]; then 
    echo start SOAPdenovo2 assembly over ssh link to $SSH_USERID@$SSH_ADDR
    rtv=$(  ssh -i $SSH_KEYFILE $SSH_USERID@$SSH_ADDR \
            "bsub \
              -o $SSH_REPORTDIR \
              $SOURCEDIR/SOAPdenovo2/run_soapdenovo2_ssh.sh \
                $SSH_CONFIGFILE $PREFIX $READS1 $READS2" \
       )
       extract_bsubid_from_rtv
  fi
}

function wait_for_assemblies_to_finish ()
{
  echo $PREFIX: ------------------------- Waiting ------------------------------
  wait $PID_ABYSS_LOCAL $PID_WGS $PID_SOAP_LOCAL
  while ( ( [[ "$DO_SSH_ABYSS_ASSEMBLY" = true ]] && [[ ! -e $ABYSS_SSH_REPORTFILE ]] ) ); do
  #		|| ( [[ "$DO_SSH_SOAPDENOVO2_ASSEMBLY" = true ]] && [[ ! -e $SOAP2_SSH_REPORTFILE ]] ) )
    echo $PREFIX: waiting for SSH assemblies
    ls $SSH_RESULTDIR_PATH/$PREFIX
    sleep 30s
  done
  echo $PREFIX: Finished waiting!!!!!!!!!!!!!!!!!!!!
}

function create_hal_database ()
{
  echo $PREFIX: -------------------- progressive cactus -------------------------
  # progressive cactus on results
  echo $PREFIX: Check to see if progessive cactus is required
  if [ "$DO_PCACTUS" = true ]; then
    echo $PREFIX: run progressive cactus
    $SOURCEDIR/progressiveCactus/run_progressive_cactus.sh $PREFIX 
    echo $PREFIX: finished running progressive cactus
  fi
}

function do_ragout_assembly ()
{
  echo $PREFIX: --------------------------- ragout -------------------------
  echo $PREFIX: check to see if regout is required
  if [ "$DO_RAGOUT" = true ]; then
    echo $PREFIX: run ragout
    $SOURCEDIR/ragout/run_ragout.sh $PREFIX 
    echo $PREFIX: finished running ragout
  fi
}

function main ()
{
  send_local_assemblies
  send_ssh_assemblies
  echo $PREFIX: Assemblies sent off !!!!!!!!!!!!!!
  wait_for_assemblies_to_finish
  create_hal_database
  do_ragout_assembly
  # Metrics?
  # Yippee!!
  echo $PREFIX: Finished!!!!!!!!!!!!
}

main "$@"

#docker rm $(docker ps -a -q)
# /home/shepperp/datashare/Piers/github/ncycseqpipe/assemble_strain.sh NCYC22 NCYC22/NCYC22.FP.fastq NCYC22/NCYC22.RP.fastq
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq
