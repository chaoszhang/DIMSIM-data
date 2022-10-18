#!/bin/bash
#PBS -q hotel
#PBS -N chaos
#PBS -l walltime=2:00:00
#PBS -l nodes=1:ppn=1

cd $PBS_O_WORKDIR


#c=`head -n $PBS_ARRAYID command | tail -n1`

#set -e
#set -x 

cd /home/chaos/immuno/tree/real/$PBS_ARRAYID
for j in 200 500; do cd /home/chaos/immuno/tree/real/$PBS_ARRAYID/$j; /home/chaos/immuno/reconstruction_tools/RAxML/raxmlHPC-AVX2 -m GTRGAMMA -s seq_with_root.fasta -n raxml-with-root -p 233; done
