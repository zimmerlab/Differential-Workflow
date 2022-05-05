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



boxplot_per_feature <- function(combined, attribute_name, value) {
  df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo)),
                   method=combined$method, readlength = factor(combined$readlen, levels = c("RL60","RL100","RL250")), fraglength = factor(combined$fraglen), sd = factor(combined$fragSD),
                   precision = combined$precision, recall = combined$recall, F1 = combined$F1)
  
  ggboxplot(df, x = "method",
            y = value, #colnames(test[,4:length(colnames(test))]),
            combine = TRUE,
            color = "black", fill = attribute_name, ncol=2) + rremove("y.title") +
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



##eval of RL FL SD
boxplot_per_feature(combined, "readlength", "precision")
boxplot_per_feature(combined, "readlength", "recall")
boxplot_per_feature(combined, "fraglength", "precision")
boxplot_per_feature(combined, "fraglength", "recall")
boxplot_per_feature(combined, "sd", "precision")
boxplot_per_feature(combined, "sd", "recall")


boxplot_per_feature(combined, "type", "precision")
boxplot_per_feature(combined, "type", "recall")

boxplot_per_feature(combined, "type", "F1")
boxplot_per_feature(combined[combined$biasinfo=="UNBIASED",], "type", "F1")

