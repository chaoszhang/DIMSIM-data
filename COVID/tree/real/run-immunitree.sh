#!/bin/bash
#PBS -q hotel
#PBS -N chaos
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1

cd $PBS_O_WORKDIR


#c=`head -n $PBS_ARRAYID command | tail -n1`

#set -e
#set -x 

module load matlab

cd /home/chaos/immuno/tree/real/$PBS_ARRAYID
for j in 10 25 50 100 200 500; do
	cd /home/chaos/immuno/tree/real/$PBS_ARRAYID/$j
	mkdir immunitree
	cp /home/chaos/immuno/targets/real/$PBS_ARRAYID/sample_condensed_${j}.fasta immunitree/${PBS_ARRAYID}_${j}.fasta
	matlab -nodisplay -nosplash -nodesktop -r "global input_dir; input_dir='/home/chaos/immuno/tree/real/$PBS_ARRAYID/$j/immunitree/'; run('/home/chaos/immuno/reconstruction_tools/immunitree_phylo/Fire/sample_driver_script.m');exit;"
	mv /home/chaos/immuno/reconstruction_tools/immunitree_phylo/Fire/output/${PBS_ARRAYID}_${j}.fasta.node.txt immunitree.txt
done
