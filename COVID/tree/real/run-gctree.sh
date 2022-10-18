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
for j in 50 100 200; do
	cd /home/chaos/immuno/tree/real/$PBS_ARRAYID/$j
	rm gctree* dnapars* out* abundances.csv
	sed "s@_[0-9]*@@g" ~/immuno/targets/real/$PBS_ARRAYID/sample_condensed_${j}.fasta > input.fasta
	deduplicate input.fasta --root root --abundance_file abundances.csv --idmapfile idmap.txt > deduplicated.phylip
	mkconfig deduplicated.phylip dnapars > dnapars.cfg
	( time /home/chaos/immuno/reconstruction_tools/phylip-3.697/exe/dnapars < dnapars.cfg > dnapars.log ) 2>&1 | tee gctree-dnapars.log
	export QT_QPA_PLATFORM=offscreen
	export XDG_RUNTIME_DIR=/tmp/runtime-runner
	export MPLBACKEND=agg
	( time gctree infer --verbose outfile abundances.csv ) 2>&1 | tee gctree.log
done
