#!/bin/bash -x
## -x : expands variables and prints commands as they are called

##
## Requires fasta index next to fasta file
##
## TODO: automate the index
##

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
LONGOPTS=index:,pdata:,samples:,out:,nthread:,log:,strand:,hisat2,star,kallisto,salmon,contextmap,stringtie,ecc,ideal,gtf:,salmonstar,paired

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

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
		--index)
        	index="$2"
            shift 2
            ;;
		--pdata)
            pdata="$2"
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
        --nthread)
            nthread="$2"
            shift 2
            ;;
        --gtf)
            gtf="$2"
            shift 2
            ;;
		--log)
			log="$2"
			shift 2
			;;
		--strand)
			strand="$2"
			shift 2
			;;
	    --hisat2)
            hisat2=y
            shift
            ;;
        --star)
            star=y
            shift
            ;;
        --kallisto)
            kallisto=y
            shift
            ;;
        --salmon)
            salmon=y
            shift
            ;;
        --salmonstar)
            salmonstar=y
            shift
            ;;
        --contextmap)
            contextmap=y
            shift
            ;;
        --stringtie)
            stringtie=y
            shift
            ;;
        --ecc)
            ecc=y
            shift
            ;;
        --ideal)
            ideal=y
            shift
            ;;
		--paired)
			paired=y
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

## Run indices
podman run --pull=always -v $index:$index -v $out:$out -v $pdata:$pdata -v $samples:$samples -v $log:$log -v $gtf:$gtf --rm hadziahmetovic/empires /home/scripts/process_generate_eq.sh ${params[@]}

