#!/bin/bash
#PBS -q hotel
#PBS -N chaos
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1

cd $PBS_O_WORKDIR


#c=`head -n $PBS_ARRAYID command | tail -n1`

#set -e
#set -x 

module load R
module load beast

cd /home/chaos/immuno/tree/real/$PBS_ARRAYID
for j in 10 25 50 100 200 500; do 
	cd /home/chaos/immuno/tree/real/$PBS_ARRAYID/$j
	rm *beast*
	python /home/chaos/immuno/reconstruction_tools/beastXML.py seq_with_root.fasta > beast.xml
	( time beast beast.xml ) 2>&1 | tee beast_time.log
	treeannotator -burnin 10000000 beast.trees.txt beast.nexus
	Rscript /home/chaos/immuno/reconstruction_tools/nexus2newick.r beast.nexus beast.tre
	sed -i "s@zero@0@g" beast.tre
	~/newick-utils-1.6/src/nw_reroot beast.tre root > beast_reroot.tre
done
