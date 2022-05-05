library(UpSetR)

results_best <- as.data.frame(read.csv(file = "/mnt/raidinput/input/own/simulations/splicing/Benchmark/validated_data/GSE59335/results/diff_splicing_outs/eval/true.table.sorted", sep = "\t", header = TRUE))
results_best[,1:20] <- sapply(results_best[,1:20], as.numeric)

results_best <- replace(results_best, results_best <= 0.95, 0)
results_best <- replace(results_best, results_best >= 0.95, 1)
results_best$gene <- NULL


df <- data.frame(reported=results_best$is_true, responsive_exons=results_best$responsive,
                 EmpiReS=results_best$ECC, rMATS=results_best$rMH, 
                 BANDITS=results_best$BgSa, DRIMSeq=results_best$DRMK,
                 DEXSeq=results_best$DEXH)
df <- data.frame(responsive_exons=results_best$responsive,
                 EmpiReS=results_best$ECC, rMATS=results_best$rMH, 
                 BANDITS=results_best$BgSa, DRIMSeq=results_best$DRMK,
                 DEXSeq=results_best$DEXH)
upset(df, sets = c("reported","responsive_exons", "EmpiReS", "rMATS", "BANDITS", "DRIMSeq", "DEXSeq"),
      keep.order = TRUE,nsets = 7, order.by = "degree", empty.intersections = "on")
upset(df, sets = c("responsive_exons", "EmpiReS", "rMATS", "BANDITS", "DRIMSeq", "DEXSeq"),
      keep.order = TRUE,nsets = 7, order.by = "degree")









#################################################################################################
movies <- read.csv( system.file("extdata", "movies.csv", package = "UpSetR"), header=T, sep=";" )
mutations <- read.csv( system.file("extdata", "mutations.csv", package = "UpSetR"), header=T, sep = ",")

annot <- read.csv(file = "/mnt/raidbiocluster/praktikum/neap_ss19/annotation/010819.annot", header = FALSE, sep = "\t")
colnames(annot) <- c("pm_id","a1_unkown","a1_confirmed","a1_rejected", 
                     "a2_unkown","a2_confirmed","a2_rejected")

eval <- as.data.frame(c(as.character(bandits.gene$V4), as.character(bandits.transcript$V4), as.character(dexseq$V4), as.character(drimseq$V4), as.character(empires$V4)))
colnames(eval) <- "gene_id"
eval["bandits.gene"] <- eval$gene_id %in% bandits.gene$V4
eval["bandits.transcript"] <- eval$gene_id %in% bandits.transcript$V4
eval["dexseq"] <- eval$gene_id %in% dexseq$V4
eval["drimseq"] <- eval$gene_id %in% drimseq$V4
eval["empires"] <- eval$gene_id %in% empires$V4

cols <- sapply(eval, is.logical)
eval[,cols] <- lapply(eval[,cols], as.numeric)

upset(eval, nsets = 5)#,attribute.plots=list(
#gridrows=60,plots=list(
#list(plot=scatter_plot, x="ReleaseDate", y="AvgRating"),
#list(plot=scatter_plot, x="ReleaseDate", y="Watches"),
#list(plot=scatter_plot, x="Watches", y="AvgRating"),
#list(plot=histogram, x="ReleaseDate")), ncols = 2))

br <- c(226, 153, 128, 9, 15)
barplot(br, names.arg = c("total", "agreement", "confirmed", "unsure", "rejected"))



results_best <- data.frame()
results_best <- as.data.frame(read.csv(file = "/mnt/raidinput/input/own/simulations/splicing/Benchmark/validated_data/GSE59335/results/diff_splicing_outs/eval/true.table.sorted", sep = "\t", header = TRUE))
row.names(results_best) <- results_best$gene

results_best <- results_best[,2:21]
results_best[,1:20] <- sapply(results_best[,1:20], as.numeric)



results_best <- replace(results_best, results_best <= 0.95, 0)
results_best <- replace(results_best, results_best >= 0.95, 1)
results_best$gene <- NULL

df <- data.frame(reported=results_best$is_true, responsive_exons=results_best$responsive,
                 EmpiReS=results_best$ECC, rMATS=results_best$rMH, 
                 BANDITS=results_best$BgSa, DRIMSeq=results_best$DRMK,
                 DEXSeq=results_best$DEXH)
df <- data.frame(responsive_exons=results_best$responsive,
                 EmpiReS=results_best$ECC, rMATS=results_best$rMH, 
                 BANDITS=results_best$BgSa, DRIMSeq=results_best$DRMK,
                 DEXSeq=results_best$DEXH)
upset(df, sets = c("reported","responsive_exons", "EmpiReS", "rMATS", "BANDITS", "DRIMSeq", "DEXSeq"),
      keep.order = TRUE,nsets = 7, order.by = "degree", empty.intersections = "on")
upset(df, sets = c("responsive_exons", "EmpiReS", "rMATS", "BANDITS", "DRIMSeq", "DEXSeq"),
      keep.order = TRUE,nsets = 7, order.by = "degree")

upset(df, sets = c("responsive_exons", "EmpiReS", "rMATS", "BANDITS", "DRIMSeq", "DEXSeq"),
      keep.order = TRUE, nsets = 7, group.by = "sets", empty.intersections = "on")

#https://cran.r-project.org/web/packages/UpSetR/vignettes/basic.usage.html

