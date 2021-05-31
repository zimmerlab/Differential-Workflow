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
LONGOPTS=index:,gtf:,pdata:,out:,nthread:,log:,dexseq,hisat2,star,contextmap,ideal,paired,unpaired

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

dexseq=n
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
		--dexseq)
			dexseq="y"
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

podman run --pull=always -v $index:$index -v $gtf:$gtf -v $pdata:$pdata -v $out:$out -v $log:$log \
	--rm hadziahmetovic/rnaseq-toolkit /home/scripts/process_featureCounts.sh ${params[@]}
