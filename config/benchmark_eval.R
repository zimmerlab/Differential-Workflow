######################################################################
###
### comparison between methods over all simulations
###
### precision/recall per method
###

library(ggpubr)
library(reshape2)
library(tidyverse)

combined <- read.csv(file = "/mnt/raidinput2/tmp/hadziahmetovic/empires_2021/output/combined_top1k.txt", header = FALSE, sep = "\t")
colnames(combined) <- c("source", "depth", "biasinfo", "readlen", "fraglen", "fragSD", "method", "precision", "recall", "F1", "tp", "fp", "called", "trues")



#########################
boxplot_merged <- function(combined) {
  df <- melt(data.frame(method = combined$method, precision = combined$precision, recall = combined$recall, f1 = combined$F1))

  ggboxplot(df, x = "method",
            y = "value",
            combine = TRUE,
            ylab = "value",
            color = "black", fill = "variable", xlab = "Method") + rremove("y.title") +
    geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
    geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
    geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
    theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
    annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
    annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)
}

boxplot_merged_by_bias <- function(combined) {
  df <- melt(data.frame(method = paste(combined$method, combined$biasinfo), precision = combined$precision, recall = combined$recall, f1 = combined$F1))
  
  ggboxplot(df, x = "method",
            y = "value",
            combine = TRUE,
            ylab = "value",
            color = "black", fill = "variable", xlab = "Method") + rremove("y.title") +
    geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
    geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
    geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
    theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
    rotate_x_text(angle = 90) +
    annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
    annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)
}
combined2 <- combined
combined2 <- combined2[combined2$source!="GSE76877",]
combined2 <- combined2[combined2$source!="ECTO",]



combined2 <- combined2[combined2$method!="Bg.SaS",]
combined2 <- combined2[combined2$method!="Bt.Sa",]
combined2 <- combined2[combined2$method!="Bt.SaS",]
combined2 <- combined2[combined2$method!="ESaS",]
combined2 <- combined2[combined2$method!="SUPPA2.K",]
combined2 <- combined2[combined2$method!="SUPPA2r",]
combined2 <- combined2[combined2$method!="rM.H",]
combined2 <- combined2[combined2$method!="rMEC.H",]
combined2 <- combined2[combined2$method!="rMEC.S",]

boxplot_merged(combined)
boxplot_merged_by_bias(combined)

#########################





boxplot_per_feature <- function(combined, attribute_name, value) {
  df <- data.frame(Data = factor(paste(combined$source, combined$depth, combined$biasinfo)),
                   method=combined$method, readlength = factor(combined$readlen, levels = c("RL60","RL100","RL250")), fraglength = factor(combined$fraglen), sd = factor(combined$fragSD),
                   precision = combined$precision, recall = combined$recall, F1 = combined$F1)
  
  ggboxplot(df, x = "method",
            y = value, #colnames(test[,4:length(colnames(test))]),
            combine = TRUE,
            color = "black", fill = attribute_name, ncol=2) + rremove("y.title") +
    geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
    geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
    geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5, 11.5,12.5), linetype="dashed") + 
    theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
    annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
    annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 11.5, xmax = 12.5, ymin = 0, ymax = 100,alpha = .2) + grids(linetype = "dashed")
}



##eval of RL FL SD
boxplot_per_feature(combined, "readlength", "precision")
boxplot_per_feature(combined, "readlength", "recall")
boxplot_per_feature(combined, "fraglength", "precision")
boxplot_per_feature(combined, "fraglength", "recall")
boxplot_per_feature(combined, "sd", "precision")
boxplot_per_feature(combined, "sd", "recall")


boxplot_per_feature(combined, "Data", "precision") 
boxplot_per_feature(combined, "Data", "recall")

boxplot_per_feature(combined, "Data", "F1")
boxplot_per_feature(combined[combined$biasinfo=="UNBIASED",], "Data", "F1")

combined2 <- combined
combined2 <- combined2[combined2$source!="GSE76877",]
combined2 <- combined2[combined2$source!="ECTO",]



combined2 <- combined2[combined2$method!="Bg.SaS",]
combined2 <- combined2[combined2$method!="Bt.Sa",]
combined2 <- combined2[combined2$method!="Bt.SaS",]
combined2 <- combined2[combined2$method!="ESaS",]
combined2 <- combined2[combined2$method!="SUPPA2.K",]
combined2 <- combined2[combined2$method!="SUPPA2r",]
combined2 <- combined2[combined2$method!="rM.H",]
combined2 <- combined2[combined2$method!="rMEC.H",]
combined2 <- combined2[combined2$method!="rMEC.S",]


boxplot_per_feature(combined2[combined2$biasinfo=="UNBIASED",], "Data", "F1")


combined3 <- combined2
#combined3 <- combined3[combined3$method!="DEX.H",]
combined3 <- combined3[combined3$method!="DEX.ID",]
combined3 <- combined3[combined3$method!="DEX.S",]
combined3 <- combined3[combined3$method!="EH",]
combined3 <- combined3[combined3$method!="ES",]
#combined3 <- combined3[combined3$method!="ECC",]
combined3 <- combined3[combined3$method!="EID",]
combined3 <- combined3[combined3$method!="EK",]
#combined3 <- combined3[combined3$method!="rM.S",]
combined3 <- combined3[combined3$method!="ESa",]

rename_labels <- function(combined) {
  combined$method <- gsub("Bg.Sa", "BANDITS", combined$method)
  combined$method <- gsub("DEX.H", "DEXSeq", combined$method)
  combined$method <- gsub("DEX.ID", "DEXSeq on IM", combined$method)
  combined$method <- gsub("DEX.S", "DEXSeq on STAR", combined$method)
  combined$method <- gsub("DRMK", "DRIMSeq", combined$method)
  combined$method <- gsub("ECC", "EmpiReS", combined$method)
  combined$method <- gsub("EH", "EmpiReS on HISAT2", combined$method)
  combined$method <- gsub("EK", "EmpiReS on kallisto", combined$method)
  combined$method <- gsub("ESa", "EmpiReS on Salmon", combined$method)
  combined$method <- gsub("ES", "EmpiReS on STAR", combined$method)
  combined$method <- gsub("EID", "EmpiReS on IM", combined$method)
  combined$method <- gsub("SUPPA2s", "SUPPA2", combined$method)
  combined$method <- gsub("rMEC.H", "rMATS", combined$method)
  combined$method <- gsub("rMEC.S", "rMATS on STAR", combined$method)
  combined$method <- gsub("rM.S", "rMATS on STAR", combined$method)
  
  return(combined)
}

combined3 <- rename_labels(combined3)

boxplot_per_feature_small <- function(combined, attribute_name, value) {
  df <- data.frame(Data = factor(paste(combined$source, combined$depth)),
                   method=combined$method, readlength = factor(combined$readlen, levels = c("RL60","RL100","RL250")), fraglength = factor(combined$fraglen), sd = factor(combined$fragSD),
                   precision = combined$precision, recall = combined$recall, F1 = combined$F1)
  
  ggboxplot(df, x = "method",
            y = value, #colnames(test[,4:length(colnames(test))]),
            combine = TRUE,
            color = "black", fill = attribute_name, ncol=2) + rremove("y.title") + rremove("x.title") +
    geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
    geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
    geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5), linetype="dashed") + 
    theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
    annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2)
}
boxplot_per_feature_small(combined3, "Data", "F1")

boxplot_per_feature_small(combined3[combined3$biasinfo=="UNBIASED",], "Data", "F1")


combined4 <- combined2
combined4 <- combined4[combined4$method!="Bg.Sa",]
combined4 <- combined4[combined4$method!="DRMK",]
combined4 <- combined4[combined4$method!="EK",]
combined4 <- combined4[combined4$method!="ESa",]
combined4 <- combined4[combined4$method!="SUPPA2s",]


boxplot_per_feature_medium <- function(combined, attribute_name, value) {
  df <- data.frame(Data = factor(paste(combined$source, combined$depth)),
                   method=combined$method, readlength = factor(combined$readlen, levels = c("RL60","RL100","RL250")), fraglength = factor(combined$fraglen), sd = factor(combined$fragSD),
                   precision = combined$precision, recall = combined$recall, F1 = combined$F1)
  
  ggboxplot(df, x = "method",
            y = value, #colnames(test[,4:length(colnames(test))]),
            combine = TRUE,
            color = "black", fill = attribute_name, ncol=2) + rremove("y.title") + rremove("x.title") +
    geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
    geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
    geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5), linetype="dashed") + 
    theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
    annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
    annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
    annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2)
}
boxplot_per_feature_medium(combined4[combined4$biasinfo=="UNBIASED",], "Data", "F1")








