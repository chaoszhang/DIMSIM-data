k=500
#for i in $(seq 1 50); do for j in dnapars_greedy igphyml immunitree raxml mst beast permut_1 permut_2 permut_3; do
for i in $(seq 45 50); do for j in igphyml immunitree mst permut_1 permut_2 permut_3; do
	x=(`python ../metric/editdist_fast.py $i/$k/$j $i/$k/truth`)
        echo $i $k $j TED ${x[0]}
	#echo $i $k $j TD ${x[1]}
done done | tee scale_$k
