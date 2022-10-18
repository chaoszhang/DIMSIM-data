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
	cd /home/chaos/immuno/tree/real/$PBS_ARRAYID/$j
	python /home/chaos/immuno/reconstruction_tools/fasta2phylip.py seq_with_root.fasta > infile
	echo "Y" | /home/chaos/immuno/reconstruction_tools/phylip-3.697/exe/dnapars
	cp outtree dnapars.tre
done
