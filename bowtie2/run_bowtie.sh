#!/bin/bash
# runAbyssLocal.sh
# $1 Config file
# $2 Assembly to map against reads AT THE MOMENT full path
# $3 First part of the paired end reads, relative to read directory
# $4 Second part of the paired end reads, relative to read directory
declare -xr SSH_CONFIGFILE=$1
declare -xr ASSEMBLY=$2
declare -xr READS1=$3
declare -xr READS2=$4
#Hard conded until I workout how to soft code
declare HPC_DATA=/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks
declare -xr ASSEMBLYDIR=$(dirname "${ASSEMBLY}")
declare -xr ASSEMBLYNAME=$(basename "$ASSEMBLY" .fasta)

source hpccore-5
source bowtie2-2.2.5
source samtools-1.0
source jdk-1.7.0_25
source $HPC_DATA/$SSH_CONFIGFILE
declare -xr METRIC_DIR=$ASSEMBLYDIR/Metrics
declare -xr SSH_READDIR=$HPC_DATA/$READDIR
mkdir -p $METRIC_DIR

echo "readir $READDIR"
echo "hpc_data $HPC_DATA"
echo "reads one $READS1"
echo "$SSH_READDIR/$READS1"

echo about to run bowtie2-build
bowtie2-build $ASSEMBLY $METRIC_DIR/$ASSEMBLYNAME
echo about to ru bowtie
bowtie2   --mm \
          --no-mixed \
          -x $METRIC_DIR/$ASSEMBLYNAME \
          -1 $SSH_READDIR/$READS1 \
          -2 $SSH_READDIR/$READS2 \
          > $METRIC_DIR/${ASSEMBLYNAME}_BOW.sam \
  | samtools view -bS - \
  | samtools sort /dev/stdin $METRIC_DIR/${ASSEMBLYNAME}_BOW_sorted
echo about to run samtools index
samtools index $METRIC_DIR/${ASSEMBLYNAME}_BOW_sorted.bam

source CGAL-0.9.6 
cd  $METRIC_DIR
echo about to run bowtie2convert
echo "bowtie2convert ${ASSEMBLYNAME}_BOW.sam 600"
bowtie2convert ${ASSEMBLYNAME}_BOW.sam 600
align ../$ASSEMBLYNAME.fasta 1000 12
cgal ../$ASSEMBLYNAME.fasta

#bsub "/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/github/ncycseqpipe/bowtie2/run_bowtie.sh   \
#  Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg \
# /nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks/Piers/assemblies/test/NCYC22/asNCYC22i_hpc.fasta \
# NCYC22/NCYC22.FP.fastq \
# NCYC22/NCYC22.RP.fastq"


#samtools view -bS $METRIC_DIR/${ASSEMBLYNAME}_BOW.sam \
#  | samtools sort /dev/stdin ${ASSEMBLYNAME}_BOW_sorted
#samtools index ${ASSEMBLYNAME}_BOW_sorted.bam
#
#HPC_DATA=/nbi/group-data/ifs/NBI/Research-Groups/Jo-Dicks
#SSH_CONFIGFILE=$HPC_DATA/Piers/github/ncycseqpipeHidden/input/ncycseqpipe.cfg
#ASSEMBLY=$HPC_DATA/Piers/assemblies/test/NCYC22/asNCYC22i_hpc.fasta
#PREFIX=NCYC22
#READS1=NCYC22/NCYC22.FP.fastq
#READS2=NCYC22/NCYC22.RP.fastq