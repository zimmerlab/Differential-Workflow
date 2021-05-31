#!/bin/bash -x

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
LONGOPTS=gtf:,pdata:,out:,nthread:,log:,hisat2,star,base:

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
declare -A paths

map[hisat]=n paths[hisat]="gene.counts.hisat"
map[star]=n paths[star]="gene.counts.star"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
		--index)
        	index="$2"
            shift 2
            ;;
		--gtf)
        	gtf="$2"
            shift 2
            ;;
		--pdata)
            pdata="$2"
            shift 2
            ;;
        --out)
            out="$2"
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
		--base)
			base="$2"
			shift 2
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

! [ -f $out/labels.map ] && sed '1d' $pdata > $out/labels.map

for method in "hisat" "star"; do

	if [[ "${map[$method]}" = "y" ]]; then
		basein=$out/${paths[$method]}
		baseout=$out/EVAL_$method
		mkdir -p $baseout

		sed -i 's/.bam//g' $basein
		
		java -cp "/home/users/hadziahmetovic/1Work/EWMS/web/WEB-INF/lib/*":/home/users/hadziahmetovic/1Work/EWMS/web/WEB-INF/classes nlEmpiRe.input.MatrixInput -idfield Geneid -matrix $basein -writedistribs -od $baseout -labels $out/labels.map
	fi
done

cp $base/generate_simul.sh $out
cp $base/generate_reads.sh $out
cp $base/create_variants.sh $out