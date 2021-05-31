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

GTF=/mnt/raidinput2/tmp/hadziahmetovic/index/annotation/Homo_sapiens.GRCh38.103.gtf
GENOME=/mnt/raidinput2/tmp/hadziahmetovic/index/annotation/Homo_sapiens.GRCh38.dna.primary_assembly.fa
GENOMEIDX=/mnt/raidinput2/tmp/hadziahmetovic/index/annotation/Homo_sapiens.GRCh38.dna.primary_assembly.fa.fai
mkdir -p COUNTS
day=`date +'%Y.%m.%d'`
MINL=600
incounts=${$1:-"gene.counts"}
NPAIRS=5000
NTRUEDIFFSPLIC=1300
NTRUEDIFFEXP_MULTITR=1000
NTRUEDIFFEXP_SINGLETR=1000

SIMULTRS=newtranscripts.$day.$MINL.$NPAIRS.list

# $ewms gobi.rnaseq.TranscriptSelection -gtf $GTF -o $SIMULTRS -splicgenesout splic.genes -nonsplicgenesout nonsplic.genes -random -npairs $NPAIRS -minl $MINL
gobi gobi.rnaseq.TranscriptSelection -gtf $GTF -o $SIMULTRS -splicgenesout splic.genes -nonsplicgenesout nonsplic.genes -random -npairs $NPAIRS -minl $MINL

let nmultitr=${NTRUEDIFFSPLIC}+${NTRUEDIFFEXP_MULTITR}
shuf splic.genes  | head -$nmultitr > multitr.genes
shuf nonsplic.genes | head -${NTRUEDIFFEXP_SINGLETR} > singletr.genes
head -${NTRUEDIFFSPLIC} multitr.genes > diffsplic.trues
cat multitr.genes singletr.genes > diffexp.trues

# generate counts on all the transcripts using the count table ../simul.depth.2 and write it to counts
ewms nlEmpiRe.test.rnaseq.GenerateTrCounts -gtf $GTF \
		-transcriptsToSimulate $SIMULTRS \
		 -diffsplic diffsplic.trues \
		 -diffexp diffexp.trues \
		 -new $incounts -od COUNTS/ > generatetrcounts.log

## test the counts
ewms nlEmpiRe.test.rnaseq.TranscriptSimulationTest -trcounts COUNTS/transcript_exprs.txt -gtf $GTF -trues COUNTS/diffsplic.trues > simultest.log