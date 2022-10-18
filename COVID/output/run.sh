for i in $(seq 1 50); do for j in dnapars_consensus dnapars_greedy igphyml igphyml_star immunitree raxml raxml_star mst beast beast_star permut_1 permut_2 permut_3; do echo $i 100 $j minus `python ../metric/cluster.py $i/100/$j $i/100/truth`; done done | tee minus
for i in $(seq 1 50); do for j in dnapars_consensus dnapars_greedy igphyml igphyml_star immunitree raxml raxml_star mst beast beast_star permut_1 permut_2 permut_3; do echo $i 100 $j plus `python ../metric/cluster_plus_trivial.py $i/100/$j $i/100/truth`; done done | tee plus
for i in $(seq 1 50); do for j in dnapars_consensus dnapars_greedy igphyml igphyml_star immunitree raxml raxml_star mst beast beast_star permut_1 permut_2 permut_3; do
	for k in mrca mrca_abs; do
		echo $i 100 $j $k `python ../metric/$k.py $i/100/$j $i/100/truth`
	done
	k=(`python ../metric/editdist_fast.py $i/100/$j $i/100/truth`)
        echo $i 100 $j TED ${k[0]}
	echo $i 100 $j TD ${k[1]}
done done | tee metric
