k=500
for i in $(seq 39 50); do for j in igphyml_star raxml_star; do
	x=(`python ../metric/editdist_fast.py $i/$k/$j $i/$k/truth`)
        echo $i $k $j TED ${x[0]}
	#echo $i $k $j TD ${x[1]}
done done | tee scale_${k}_4
