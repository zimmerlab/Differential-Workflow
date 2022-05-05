#!/bin/zsh -x

res1=$(date +%s.%N)

maxjobs=6
counter=1

for readlen in 60 100 250; do
	for frlen in 200 400 600; do
		for sd in 40 80; do
			./generate_reads.sh $readlen $frlen $sd > generate_reads_combined_RL${readlen}_FR${frlen}_SD${sd}.log &
			
			let counter=counter+1
			if [ $counter -gt $maxjobs ]; then
				wait
				counter=1
			fi
		done
    done
done

wait

res2=$(date +%s.%N)
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)

##mail :)
echo "$pwd has finished processing!"$'\n'"Execution time:"`LC_NUMERIC=C printf "Total runtime: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds`$'\n'"$*" | mail -s "Finished job on $HOSTNAME" hadziahmetovic@cip.ifi.lmu.de
