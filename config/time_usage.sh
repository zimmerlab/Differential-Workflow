#!/bin/zsh


root=$1

for file in `ls $root | grep pidstat`; do
	name=`echo $file | cut -d"-" -f1`
	start=`head $root/$file | grep -A1 "#" | grep -v "#" | head -1 | tr -s " "  "\t" | cut -f1`
	end=`tail $root/$file | grep -v "#" | grep -v "Linux" | tail -1 | tr -s " "  "\t" | cut -f1`

	([[ "$start" == "" ]]  || [[ "$end" == "" ]] ) && continue
	if [ "$start" -eq "$start" ] && [ "$end" -eq "$end" ] 2>/dev/null ; then echo $(($end - $start))$'\t'$name; fi
done
