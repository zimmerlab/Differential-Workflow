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
LONGOPTS=gtf:,out:,log:,exp:,splic:,trlist:,

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
		--log)
			log="$2"
			shift 2
			;;
		--exp)
            exp="$2"
            shift 2
            ;;
        --splic)
            splic="$2"
            shift 2
            ;;
		--trlist)
			trlist="$2"
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


podman run --pull=always -v $trlist:$trlist -v $out:$out -v $gtf:$gtf -v $exp:$exp -v $splic:$splic --rm -it hadziahmetovic/empire \
 java -cp /home/software/nlEmpiRe.jar nlEmpiRe.release.GenerateSimulatedTrCounts -transcriptsToSimulate $trlist -incounts $out/gene.counts -gtf $gtf -od $out -diffexp $exp -diffsplic $splic

##java -cp /home/proj/software/nlEmpiRe/nlEmpiRe.jar nlEmpiRe.release.GenerateSimulatedTrCounts -transcriptsToSimulate $trlist -incounts $out/gene.counts -gtf $gtf -od $out -diffexp $exp -diffsplic $splic