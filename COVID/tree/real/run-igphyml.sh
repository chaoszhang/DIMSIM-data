#!/bin/bash
#PBS -q hotel
#PBS -N chaos
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1

cd $PBS_O_WORKDIR


#c=`head -n $PBS_ARRAYID command | tail -n1`

#set -e
#set -x 

cd /home/chaos/immuno/tree/real/$PBS_ARRAYID
for j in 10 25 50 100 200 500; do
	cd /home/chaos/immuno/tree/real/$PBS_ARRAYID/$j;
	cp /home/chaos/immuno/targets/real/$PBS_ARRAYID/sample_condensed_${j}_dedup.fasta seq_with_root.fasta
	cat /home/chaos/immuno/setup/root_seq.fasta >> seq_with_root.fasta
	/home/chaos/immuno/reconstruction_tools/igphyml/src/igphyml -i seq_with_root.fasta -m HLP --root root --run_id igphyml
done
