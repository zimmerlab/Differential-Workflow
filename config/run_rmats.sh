#!/bin/bash -x
## -x : expands variables and prints commands as they are called

echo $@
params=("$@")

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=
LONGOPTS=pdata:,index:,samples:,out:,nthread:,log:,hisat2,star,contextmap,ideal,rmats,gtf:,readlength:,

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

declare -A map

pdata=- out=- index=- nthread=4 map[hisat]=n map[star]=n
map[contextmap]=n map[ideal]=n map[rmats]=n readlength=0
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        --pdata)
            pdata="$2"
            shift 2
            ;;
		--index)
        	index="$2"
            shift 2
            ;;
		--samples)
        	samples="$2"
            shift 2
            ;;
		--out)
        	out="$2"
            shift 2
            ;;
		--gtf)
        	gtf="$2"
            shift 2
            ;;
		--readlength)
        	readlength="$2"
            shift 2
            ;;
        --nthread)
        	nthread="$2"
            shift 2
            ;;
		--log)
        	log="$2"
            shift 2
            ;;
	    --hisat2)
            map[hisat]=y
            shift
            ;;
        --star)
            map[star]=y
            shift
            ;;
        --contextmap)
            map[contextmap]=y
            shift
            ;;
        --ideal)
            map[ideal]=y
            shift
            ;;
        --rmats)
            map[rmats]=y
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            shift
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 0 ]]; then
    echo "$0: empty flag detected, is this intentional?!"
    #exit 4
fi


#file1=$outDir/diff_splicing_outs/rMATS/b1.txt
#file2=$outDir/diff_splicing_outs/rMATS/b2.txt
#[ ! -f $file1 ] && [ ! -f $file2 ] && touch $file1 $file2
#while read line; do 
#	cond=`cut -f2 line`
#	[ "$cond" == "0" ] && 
#	[ "$cond" == "1" ] && 
#done < $pData

#echo "[INFO] [rMATS] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Creating b-files..."
#cat $pData | grep -P "\t0" | awk '$0="/home/data/out/HISAT/dta/"$0'  | cut -f1 |  tr "\\n" "," | sed 's/,/.bam,/'g | rev | cut -c 2- | rev > $file1
#cat $pData | grep -P "\t1" | awk '$0="/home/data/out/HISAT/dta/"$0'  | cut -f1 |  tr "\\n" "," | sed 's/,/.bam,/'g | rev | cut -c 2- | rev > $file2

conds=()

base=$out/rMATS
dir=$(basename $out)
mkdir -p $base
rm -f $base/*

rmats_call="podman run --pull=always -v $gtf:$gtf -v $out:$out --rm -it xinglab/rmats:v4.1.1"

## 1 create s1 and s2 files
for cond in `sed '1d' $pdata | cut -f2 | sort -u`; do
	for sample in `grep -P "\t$cond" $pdata | cut -f1`; do
		echo $samples/${sample}_1.fastq.gz:$samples/${sample}_2.fastq.gz >> $base/$cond.txt

		echo $out/HISAT/dta//$sample.bam >> $base/$cond.hisat
		echo $out/STAR/quant/$sample.bam >> $base/$cond.star
		echo $out/CONTEXTMAP/$sample.bam >> $base/$cond.contextmap
		echo $out/IDEAL/$sample.bam >> $base/$cond.ideal
	done
	cat $base/$cond.txt | tr "\\n" "," | rev | cut -c 2- | rev > $base/$cond.rmats.samples
	cat $base/$cond.hisat | tr "\\n" "," | rev | cut -c 2- | rev > $base/$cond.hisat.samples
	cat $base/$cond.star | tr "\\n" "," | rev | cut -c 2- | rev > $base/$cond.star.samples
	cat $base/$cond.contextmap | tr "\\n" "," | rev | cut -c 2- | rev > $base/$cond.contextmap.samples
	cat $base/$cond.ideal | tr "\\n" "," | rev | cut -c 2- | rev > $base/$cond.ideal.samples

	conds+=( "$cond" )
done


## this might fail for very long read lengths
if [[ "$readlength" = "0" ]]; then
	file=`head -1 $base/$cond.txt | cut -d":" -f1`
	#readlength=$((`head -100 $file | zcat | head -2 | tail -1 | wc -c`-1))
	readlength=$(head -n 2 < <(zcat $file) | tail -n 1 | tr -d '\n' | tr -d '\r' | wc -c)
fi

#rMATS	TODO add rmats mapping
for method in "hisat" "star" "contextmap" "ideal" "rmats"; do

	if [[ "${map[$method]}" = "y" ]]; then
		mkdir -p $out/diff_splicing_outs/rMATS_$method

		#watch pidstat -dru -hl >> $log/rmats_$method-$(date +%s).pidstat & wid=$!
		wid="$(date +%s)"

		( [ -f "$out/diff_splicing_outs/rMATS_$method/SE.MATS.JC.txt" ] && echo "[INFO] [rMATS] $out/diff_splicing_outs/rMATS_$method/SE.MATS.JC.txt already exists, skipping.."$'\n' ) \
			|| ($rmats_call --b1 $out/rMATS/${conds[0]}.$method.samples --b2 $out/rMATS/${conds[1]}.$method.samples \
				--gtf $gtf -t paired --nthread $nthread --od $out/diff_splicing_outs/rMATS_$method --readLength $readlength --tmp /tmp)

		#kill -15 $wid
		echo "$(($(date +%s)-$wid))" >> $log/rmats_${dir}_${method}.$(date +%s).runtime
	fi
done
 	#-t paired --libType fr-unstranded --readLength $readLength --gtf $gtf --od $outDir/diff_splicing_outs/rMATS --nthread $nthreads )

echo "[INFO] [rMATS] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Splicing analysis finished"$'\n'

## Run indices
