#!/bin/zsh -x
###
# INFO for Gergely: ist hier als zsh script weil hier ewms gesetzt ist aber mein ewms = dein $emws (+-)
# 
# $ which emws
# java -cp "/home/users/hadziahmetovic/1Work/EWMS/web/WEB-INF/lib/*":/home/users/hadziahmetovic/1Work/EWMS/web/WEB-INF/classes
#
# which gobi
# java -cp "/home/users/hadziahmetovic/1Work/Gobi/web/WEB-INF/lib/*":/home/users/hadziahmetovic/1Work/Gobi/web/WEB-INF/classes
###
source ~/.zshrc_local

readlen=${1:-100}
frlen=${2:-200}
sd=${3:-80}

## generate reads
root="RL${readlen}_FR${frlen}_SD${sd}"
biasdir="BIASED_"$root
normaldir="UNBIASED_"$root
biaspos="/home/proj/software/nlEmpiRe/POSITIONWISE_BIAS/yeast.tr2startfreq.out"
trcounts="COUNTS/transcript_exprs.txt"
GTF=/mnt/raidinput2/tmp/hadziahmetovic/index/annotation/Homo_sapiens.GRCh38.103.gtf
GENOME=/mnt/raidinput2/tmp/hadziahmetovic/index/annotation/Homo_sapiens.GRCh38.dna.primary_assembly.fa
GENOMEIDX=/mnt/raidinput2/tmp/hadziahmetovic/index/annotation/Homo_sapiens.GRCh38.dna.primary_assembly.fa.fai

out="/mnt/raidtmp/hadziahmetovic/empires_2021/output/""$(basename `pwd`)"
base=$(basename `pwd`)

mkdir -p $biasdir
mkdir -p $normaldir

java -jar /home/proj/software/nlEmpiRe/RELEASE/empires.jar generate_reads \
	-gtf $GTF \
	-genome $GENOME \
	-genomeidx $GENOMEIDX \
	-trcounts $trcounts \
	-od $normaldir \
	-readlength $readlen \
	-fraglengthmean $frlen \
	-fraglengthsd $sd \
	> generate_reads_$normaldir.log

cd $normaldir 
for bam in `ls | grep bam`; do mv $bam $bam.tmp; samtools sort -@ 8 -o $bam $bam.tmp; rm $bam.tmp; done
cd ..

java -jar /home/proj/software/nlEmpiRe/RELEASE/empires.jar generate_reads \
	-gtf $GTF \
	-genome $GENOME \
	-genomeidx $GENOMEIDX \
	-trcounts $trcounts \
	-biaspos $biaspos \
	-od $biasdir \
	-readlength $readlen \
	-fraglengthmean $frlen \
	-fraglengthsd $sd \
	> generate_reads_$biasdir.log

cd $biasdir
for bam in `ls | grep bam`; do mv $bam $bam.tmp; samtools sort -@ 8 -o $bam $bam.tmp; rm $bam.tmp; done
cd ..

[[ -f "workflow.table" ]] || echo 'label\tpdata\tout\tsamples\ttruesplic' > workflow.table
echo ${base}_$biasdir$'\t'`pwd`"/pdata.txt"$'\t'${out}_$biasdir$'\t'`pwd`/$biasdir$'\t'`pwd`/COUNTS/diffsplic.trues >> workflow.table
echo ${base}_$normaldir$'\t'`pwd`"/pdata.txt"$'\t'${out}_$normaldir$'\t'`pwd`/$normaldir$'\t'`pwd`/COUNTS/diffsplic.trues >> workflow.table
