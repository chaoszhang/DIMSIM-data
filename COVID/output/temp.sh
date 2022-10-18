for i in 1 2 $(seq 4 31) $(seq 33 50); do for j in gctree; do echo $i 100 $j minus `python ../metric/cluster.py $i/100/$j $i/100/truth`; done done | tee -a minus
for i in 1 2 $(seq 4 31) $(seq 33 50); do for j in gctree; do echo $i 100 $j plus `python ../metric/cluster_plus_trivial.py $i/100/$j $i/100/truth`; done done | tee -a plus
for i in 1 2 $(seq 4 31) $(seq 33 50); do for j in gctree; do
	for k in mrca mrca_abs; do
		echo $i 100 $j $k `python ../metric/$k.py $i/100/$j $i/100/truth`
	done
	k=(`python ../metric/editdist_fast.py $i/100/$j $i/100/truth`)
        echo $i 100 $j TED ${k[0]}
	echo $i 100 $j TD ${k[1]}
done done | tee -a metric
