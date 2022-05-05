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

######################################################################
###
### everything combined, only shows methods
### Figure 5.1Evaluation of method performances.
###
df <- melt(data.frame(method = combined$method, precision = combined$precision, recall = combined$recall))

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

#ggplot(reads, aes(x=method, y=value, fill=variable)) + geom_boxplot() + 
#  scale_x_discrete(expand = expand_scale(add=1)) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))


######################################################################
###
### plot for all data sets for all method combis with shaded areas
### Figure 5.2: Evaluation of the simulated data sets.
###
reads <- melt(data.frame(source = factor(paste(combined$source, combined$depth, sep = "_")), type = combined$biasinfo,
                         method = combined$method, precision = combined$precision, recall = combined$recall))
df <- reads %>%
  group_by(source) %>%
  mutate(grouped_id=row_number())

test <- spread(df, source, value)
ggboxplot(test, x = "method",
          y = colnames(test[,5:length(colnames(test))]),
          combine = TRUE,
          ylab = "value",
          color = "black", fill = "variable", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)
#scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) 

#ggplot(reads, aes(x=method, y=value, fill=variable)) + geom_boxplot() + 
#  scale_x_discrete(expand = expand_scale(add=1)) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))


######################################################################
###
### for all individual combis of data biasinfo :)
### Supplementary figure:
###
### might need to cut this plot in half and present over two pages, as it is too much data
reads <- melt(data.frame(source = factor(paste(combined$source, combined$depth, combined$biasinfo)),
                         method = combined$method, prec = combined$precision, rec = combined$recall))
df <- reads %>%
  group_by(source) %>%
  mutate(grouped_id=row_number())

test <- spread(df, source, value)
ggboxplot(test, x = "method",
          y = colnames(test[,4:length(colnames(test))]),
          combine = TRUE,
          ylab = "value",
          color = "black", fill = "variable", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)



#################################################################################################################################################################



###################################################################### >>>>>>>>>>>>>>>>>>< need to add sorting for RL
###
### per method change in precision
### Figure 5.4 Simulation read length impact on performance per method -> (a) precision
###
df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo)),
                 method=combined$method , readlength = factor(combined$readlen), precision = combined$precision)

ggboxplot(df, x = "method",
          y = "precision", #colnames(test[,4:length(colnames(test))]),
          combine = TRUE,
          color = "black", fill = "readlength", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)

#ggplot(df, aes(x=method, y=precision, fill=readlength)) + geom_boxplot() + 
#  scale_x_discrete(expand = expand_scale(add=1)) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))


######################################################################
###
### per method change in recall
### Figure 5.4 Simulation read length impact on performance per method -> (b) recall
###
df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo)),
                 method=combined$method , readlength = factor(combined$readlen), recall = combined$recall)

ggboxplot(df, x = "method",
          y = "recall", #colnames(test[,4:length(colnames(test))]),
          combine = TRUE,
          color = "black", fill = "readlength", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)

#ggplot(df, aes(x=method, y=rec, fill=readlength)) + geom_boxplot() + 
#  scale_x_discrete(expand = expand_scale(add=1)) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))


######################################################################
###
### per data set change in precision
### Figure 5.5 Simulation read length impact on precision per data set
###
df <- melt(data.frame(type = factor(paste(combined$source, combined$depth)), method = combined$method,
                      readlength = factor(combined$readlen), precision = combined$precision))
df <- df %>%
  group_by(type) %>%
  mutate(grouped_id=row_number())

test <- spread(df, type, value)
ggboxplot(test, x = "method",
          y = colnames(test[,5:length(colnames(test))]), #c("EBVD2", "STEM", "EBVD5", "ECTODERM", "EBVD10"),
          combine = TRUE,
          color = "black", fill = "readlength", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)


######################################################################
###
### per data set change in recall
### Figure 5.6 Simulation read length impact on recall per data set
###
df <- melt(data.frame(type = factor(paste(combined$source, combined$depth)), method = combined$method,
                      readlength = factor(combined$readlen), recall = combined$recall))
df <- df %>%
  group_by(type) %>%
  mutate(grouped_id=row_number())

test <- spread(df, type, value)
ggboxplot(test, x = "method",
          y = colnames(test[,5:length(colnames(test))]), #c("EBVD2", "STEM", "EBVD5", "ECTODERM", "EBVD10"),
          combine = TRUE,
          color = "black", fill = "readlength", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)


######################################################################
###
### per read length pair change in precision
### Figure 5.7 Simulation read length impact on performance of DAS methods -> (a) precision
###
slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo, combined$method, combined$fraglen)),
                       readlen = combined$readlen, precision = combined$precision)

ggplot(slope_df %>% group_by(type) %>% filter( n() == 2 ) %>%
         mutate(slope= precision[readlen == 100] - precision[readlen == 60]),
       aes(readlen, precision, group=type, colour=slope > 0)) +
  geom_point() + geom_line() + scale_x_discrete(limits=c(60, 100), labels=c("60", "100"), expand = expand_scale(add=2)) +
  theme_classic(base_size = 18) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) + labs(x = "Read length", y = "Precision")

###
### per method increase -> (c)
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo, combined$fraglen)),
                       readlen = combined$readlen, method = combined$method, precision = combined$precision)

ggboxplot(slope_df %>% group_by(type, method) %>% filter( n() == 2 ) %>%
            mutate(slope= precision[readlen == 100] - precision[readlen == 60]),
          x = "method", y = "slope",
          ylab = "gain in precision 60 - 100 bp",
          color = "black", fill = "method", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=0, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=2.5, linetype = "dashed", color = "darkred") +
  scale_y_continuous(expand = c(0, 5), limits = c(-50, 70)) + theme(legend.position = "none")


######################################################################
###
### per read length pair change in recall
### Figure 5.7 Simulation read length impact on performance of DAS methods -> (b) recall
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo, combined$method, combined$fraglen)),
                       readlen = combined$readlen, recall = combined$recall)

ggplot(slope_df %>% group_by(type) %>% filter( n() == 2 ) %>%
         mutate(slope= recall[readlen == 100] - recall[readlen == 60]),
       aes(readlen, recall, group=type, colour=slope > 0)) +
  geom_point() + geom_line() + scale_x_discrete(limits=c(60, 100), labels=c("60", "100"), expand = expand_scale(add=2)) +
  theme_classic(base_size = 18) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) + labs(x = "Read length", y = "Recall")

###
### per method increase -> (d)
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo, combined$fraglen)),
                       readlen = combined$readlen, method = combined$method, recall = combined$recall)

ggboxplot(slope_df %>% group_by(type, method) %>% filter( n() == 2 ) %>%
            mutate(slope= recall[readlen == 100] - recall[readlen == 60]),
          x = "method", y = "slope",
          ylab = "gain in recall 60 - 100 bp",
          color = "black", fill = "method", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=0, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=10, linetype = "dashed", color = "darkred") +
  scale_y_continuous(expand = c(0, 5), limits = c(-50, 70)) + theme(legend.position = "none")


######################################################################
###
### per read length pair change in precision
### Figure 5.8 Simulation fragment length impact on performance of DAS methods -> (a) precision
###

slope_df <- data.frame(type = paste(combined$source, combined$depth, combined$biasinfo, combined$method, combined$readlen),
                       fraglen = combined$fraglen, precision = combined$precision)

ggplot(slope_df %>% group_by(type) %>% filter( n() == 2 ) %>%
         mutate(slope= precision[fraglen == 500] - precision[fraglen == 200]),
       aes(fraglen, precision, group=type, colour=slope > 0)) +
  geom_point() + geom_line() + scale_x_discrete(expand = expand_scale(add=0.05)) +
  theme_classic(base_size = 18) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) + labs(x = "Fragment length", y = "Precision")

###
### per method increase -> (c)
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo, combined$readlen)),
                       fraglen = combined$fraglen, method = combined$method, precision = combined$precision)

ggboxplot(slope_df %>% group_by(type, method) %>% filter( n() == 2 ) %>%
            mutate(slope= precision[fraglen == 400] - precision[fraglen == 200]),
          x = "method", y = "slope",
          ylab = "gain in precision 200 - 400 fraglen",
          color = "black", fill = "method", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=0, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=5, linetype = "dashed", color = "darkred") +
  scale_y_continuous(expand = c(0, 5), limits = c(-25, 25)) + theme(legend.position = "none")


######################################################################
###
### per read length pair change in recall
### Figure 5.8 Simulation fragment length impact on performance of DAS methods -> (b) recall
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo, combined$method, combined$readlen)),
                       fraglen = combined$fraglen, recall = combined$recall)

ggplot(slope_df %>% group_by(type) %>% filter( n() == 2 ) %>%
         mutate(slope= recall[fraglen == 400] - recall[fraglen == 200]),
       aes(fraglen, recall, group=type, colour=slope > 0)) +
  geom_point() + geom_line() + scale_x_discrete(expand = expand_scale(add=0.05)) +
  theme_classic(base_size = 18) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) + labs(x = "Fragment length", y = "Recall")

###
### per method increase -> (d)
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$biasinfo, combined$readlen)),
                       fraglen = combined$fraglen, method = combined$method, recall = combined$recall)

ggboxplot(slope_df %>% group_by(type, method) %>% filter( n() == 2 ) %>%
            mutate(slope= recall[fraglen == 400] - recall[fraglen == 200]),
          x = "method", y = "slope",
          ylab = "gain in recall 60 - 100 bp",
          color = "black", fill = "method", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=0, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=5, linetype = "dashed", color = "darkred") +
  scale_y_continuous(expand = c(0, 5), limits = c(-25, 25)) + theme(legend.position = "none")


##################################################################################################################################################

###################################################################### <<<<<<<<<<<<<< NEED to add the plots to be made on basis of D-level
###
### per method change in precision and recall
### Figure 5.10 Simulation depth impact on performance -> (a) precision
###

df <- data.frame(type = factor(paste(combined$biasinfo, combined$readlen, combined$fraglen)),
                 method=combined$method , source = factor(combined$depth, levels = c("D2","D4", "D5", "D10")), precision = combined$precision)

df$grp <- paste(df$method,df$type)

ggplot(df,
       aes(source, precision, group=grp, colour=method)) +
  geom_point() + geom_line()  +
  theme_classic(base_size = 18) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) + labs(x = "Depth level", y = "Precision")

###
### -> (b) recall
###

df <- data.frame(type = factor(paste(combined$biasinfo, combined$readlen, combined$fraglen)),
                 method=combined$method , source = factor(combined$depth, levels = c("D2","D4", "D5", "D10")), recall = combined$recall)

df$grp <- paste(df$method,df$type)

ggplot(df,
       aes(source, recall, group=grp, colour=method)) +
  geom_point() + geom_line()  +
  theme_classic(base_size = 18) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) + labs(x = "Depth level", y = "Recall")


######################################################################
###
### per method change in precision and recall
### Figure 5.11 Simulation depth impact on performance per method -> (a) precision
###

df <- data.frame(type = factor(paste(combined$biasinfo, factor(combined$readlen))),
                 method=combined$method , source = factor(combined$depth, levels = c("D2","D4", "D5", "D10")), precision = combined$precision)

ggboxplot(df, x = "method",
          y = "precision",
          combine = TRUE,
          color = "black", fill = "source", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)

###
### -> (b) recall
###

df <- data.frame(type = factor(paste(combined$biasinfo, combined$readlen, combined$fraglen)),
                 method=combined$method , source = factor(combined$depth, levels = c("D2","D4", "D5", "D10")), recall = combined$recall)

ggboxplot(df, x = "method",
          y = "recall",
          combine = TRUE,
          color = "black", fill = "source", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)


######################################################################################################################################################

######################################################################
###
### per method change in precision and recall
### Figure 5.12 Simulation type impact on performance per method -> (a)
###

df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$readlen)),
                 method=combined$method , biasinfo = factor(combined$biasinfo), precision = combined$precision)

ggboxplot(df, x = "method",
          y = "precision",
          combine = TRUE,
          color = "black", fill = "biasinfo", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)

###
### per method change in recall -> (b)
###

df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$readlen)),
                 method=combined$method , biasinfo = factor(combined$biasinfo), recall = combined$recall)

ggboxplot(df, x = "method",
          y = "recall", #colnames(test[,4:length(colnames(test))]),
          combine = TRUE,
          color = "black", fill = "biasinfo", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)


######################################################################
###
### per data set precision
### Figure 5.13 Simulation type impact on precision per data set
###

df <- melt(data.frame(type = factor(paste(combined$source, combined$depth)), method = combined$method,
                      biasinfo = factor(combined$biasinfo), precision = combined$precision))

df <- df %>%
  group_by(type) %>%
  mutate(grouped_id=row_number())

test <- spread(df, type, value)
ggboxplot(test, x = "method",
          y = colnames(test[,5:length(colnames(test))]), #c("EBVD2", "STEM", "EBVD5", "ECTODERM", "EBVD10"),
          combine = TRUE,
          #ylab = "value",
          color = "black", fill = "biasinfo", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)


######################################################################
###
### per data set recall
### Figure 5.14 Simulation type impact on recall per data set
###
df <- melt(data.frame(type = factor(paste(combined$source, combined$depth)), method = combined$method,
                      biasinfo = factor(combined$biasinfo), recall = combined$recall))
df <- df %>%
  group_by(type) %>%
  mutate(grouped_id=row_number())

test <- spread(df, type, value)
ggboxplot(test, x = "method",
          y = colnames(test[,5:length(colnames(test))]), #c("EBVD2", "STEM", "EBVD5", "ECTODERM", "EBVD10"),
          combine = TRUE,
          #ylab = "value",
          color = "black", fill = "biasinfo", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)


#################################################################################################################
###
### pairwise change
### Figure 5.15 Simulation type impact on performance per method -> (a) precision         >>>>>>>>>>>>>>>>changed here some stuff -> factors etc
###

slope_df <- data.frame(type = paste(combined$source, combined$depth, combined$method, combined$readlen, combined$fraglen),
                       biasinfo = factor(combined$biasinfo),  precision = combined$precision, stringsAsFactors = FALSE)

slope_df[is.na(slope_df)] <- 0

ggplot(slope_df %>% group_by(type) %>% filter( n() == 2 ) %>%
         mutate(slope = (precision[biasinfo == "BIASED"] - precision[biasinfo == "UNBIASED"])),
       aes(biasinfo, precision, group=type, colour=slope > 0), ylim = c(0, 100)) +
  geom_point() + geom_line() + scale_x_discrete(expand = expand_scale(add=.05), limits = rev(levels(reads$biasinfo))) +  
  theme_classic(base_size = 18) + expand_limits(y = 0)

###
### per method change in sensitivity -> (c)
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$readlen, combined$fraglen)),
                       method = combined$method, biasinfo = factor(combined$biasinfo),  precision = combined$precision)

ggboxplot(slope_df %>% group_by(type, method) %>% filter( n() == 2) %>%
            mutate(slope = (precision[biasinfo == "BIASED"] - precision[biasinfo == "UNBIASED"])),
          x = "method", y = "slope",
          ylab = "gain in precision unbiased to biased",
          color = "black", fill = "method", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=0, linetype = "dashed", color = "blue") +
  #geom_hline(yintercept=2.5, linetype = "dashed", color = "darkred") +
  scale_y_continuous(expand = c(0, 5), limits = c(-50, 50)) + theme(legend.position = "none")


######################################################################
###
### recall -> (b)
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$method, combined$readlen, combined$fraglen)),
                       biasinfo = factor(combined$biasinfo),  recall = combined$recall)

ggplot(slope_df %>% group_by(type) %>% filter( n() == 2) %>%
         mutate(slope = (recall[biasinfo == "BIASED"] - recall[biasinfo == "UNBIASED"])),
       aes(biasinfo, recall, group=type, colour=slope > 0), ylim = c(0, 100)) +
  geom_point() + geom_line() + scale_x_discrete(expand = expand_scale(add=.1), limits = rev(levels(reads$biasinfo))) +  
  theme_classic(base_size = 18) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))#expand_limits(y = 0)

###
### per method change in recall -> (d)
###

slope_df <- data.frame(type = factor(paste(combined$source, combined$depth, combined$readlen, combined$fraglen)),
                       method = combined$method, biasinfo = factor(combined$biasinfo),  recall = combined$recall)

ggboxplot(slope_df %>% group_by(type, method) %>% filter( n() == 2) %>%
            mutate(slope = (recall[biasinfo == "BIASED"] - recall[biasinfo == "UNBIASED"])),
          x = "method", y = "slope",
          ylab = "gain in recall unbiased to biased",
          color = "black", fill = "method", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=0, linetype = "dashed", color = "blue") +
  #geom_hline(yintercept=2.5, linetype = "dashed", color = "darkred") +
  scale_y_continuous(expand = c(0, 5), limits = c(-50, 50)) + theme(legend.position = "none")


######################################################################################################################################################


######################################################################
###
### everything combined, only shows methods
### Figure 5.1Evaluation of method performances.
###

df <- melt(data.frame(method = combined$method, precision = combined$precision, recall = combined$recall))

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

#ggplot(reads, aes(x=method, y=value, fill=variable)) + geom_boxplot() + 
#  scale_x_discrete(expand = expand_scale(add=1)) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))


######################################################################
###
### plot for all data sets for all method combis with shaded areas
### Figure 5.2: Evaluation of the simulated data sets.
###
reads <- melt(data.frame(source = factor(combined$source, combined$depth), type = combined$biasinfo,
                         method = combined$method, precision = combined$precision, recall = combined$recall))
df <- reads %>%
  group_by(source) %>%
  mutate(grouped_id=row_number())

test <- spread(df, source, value)
#colnames(test) <- c("type", "method", "variable", "grouped_id", "EBV", "Ectoderm", "Stem")
ggboxplot(test, x = "method",
          y = colnames(test[,5:length(colnames(test))]), #c("EBV", "Ectoderm", "Stem"), # 
          combine = TRUE,
          ylab = "value",
          color = "black", fill = "variable", ncol = 1,
          xlab = "Method") + 
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)


####################################################################################################################################################


###################################################################### >>>>>>>>>>>>>>> for this need to eval also with the DE results!!!
###
### everything combined, only shows methods
### Figure 5.16 Per method evaluation of false DE identification as DAS 
###

df <- melt(data.frame(method = formatted$method, precision = formatted$prec_diffexp, recall = formatted$rec_diffexp))

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
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2) +
  geom_hline(yintercept=2.5, linetype = "dashed", color = "darkred")


#ggplot(reads, aes(x=method, y=value, fill=variable)) + geom_boxplot() + 
#  scale_x_discrete(expand = expand_scale(add=1)) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))


######################################################################
###
### plot for all data sets for all method combis with shaded areas
### Figure 5.17 Per data set evaluation of false DE identification as DAS
###
reads <- melt(data.frame(source = factor(formatted$source), type = formatted$biasinfo,
                         method = formatted$method, precision = formatted$prec_diffexp, recall = formatted$rec_diffexp))
df <- reads %>%
  group_by(source) %>%
  mutate(grouped_id=row_number())

test <- spread(df, source, value)
ggboxplot(test, x = "method",
          y = c("EBVD2", "STEM", "EBVD5", "ECTODERM", "EBVD10"), # colnames(test[,5:length(colnames(test))]),
          combine = TRUE,
          ylab = "value",
          color = "black", fill = "variable", ncol = 2,
          xlab = "Method") + 
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2) +
  geom_hline(yintercept=2.5, linetype = "dashed", color = "darkred")

#scale_y_continuous(expand = c(0, 5), limits = c(0, 100)) 

#ggplot(reads, aes(x=method, y=value, fill=variable)) + geom_boxplot() + 
#  scale_x_discrete(expand = expand_scale(add=1)) + scale_y_continuous(expand = c(0, 5), limits = c(0, 100))


######################################################################
###
### for all individual combis of data biasinfo :)
### Supplementary figure:
###
### might need to cut this plot in half and present over two pages, as it is too much data

reads <- melt(data.frame(source = factor(paste(formatted$source, combined$depth, formatted$biasinfo)),
                         method = formatted$method, prec = formatted$prec_diffexp, rec = formatted$rec_diffexp))
df <- reads %>%
  group_by(source) %>%
  mutate(grouped_id=row_number())

test <- spread(df, source, value)
ggboxplot(test, x = "method",
          y = colnames(test[,5:length(colnames(test))]),
          combine = TRUE,
          ylab = "value",
          color = "black", fill = "variable", ncol=2) + rremove("y.title") +
  geom_hline(yintercept=80, linetype = "dashed", color = "blue") +
  geom_hline(yintercept=95, linetype = "dashed", color = "darkred") + rremove("y.title") + 
  geom_vline(xintercept=c(1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5), linetype="dashed") + 
  theme(legend.key.size = unit(1.5, "cm"), legend.key.width = unit(1.5, "cm"), legend.title = element_text(size = 14)) +
  annotate("rect", xmin = 1.5, xmax = 2.5, ymin = 0, ymax = 100,alpha = .2) + 
  annotate("rect", xmin = 3.5, xmax = 4.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 5.5, xmax = 6.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 7.5, xmax = 8.5, ymin = 0, ymax = 100,alpha = .2) +
  annotate("rect", xmin = 9.5, xmax = 10.5, ymin = 0, ymax = 100,alpha = .2)

