for n in 50 100 200 500; do for i in $(seq 1 50); do for j in truth yaari; do echo $i $n $j `python3 ../metric/treestats.py $i/$n/$j`; done done done | tee yaari
