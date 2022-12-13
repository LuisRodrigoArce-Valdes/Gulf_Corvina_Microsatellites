rm(list = ls())

# Calling libraries
library(ggplot2)
library(tidyr)
library(gridExtra)

# Reading input files
ks <- list()
ks$k2 <- read.table("../02_NoNulls/NoNulls/Results/NoNulls_run_10_q", header = F, sep = "")
ks$k3 <- read.table("../02_NoNulls/NoNulls/Results/NoNulls_run_15_q", header = F, sep = "")
ks$k4 <- read.table("../02_NoNulls/NoNulls/Results/NoNulls_run_20_q", header = F, sep = "")
ks$k5 <- read.table("../02_NoNulls/NoNulls/Results/NoNulls_run_25_q", header = F, sep = "")

# For looping for every Q
for(i in 1:length(ks)){
 ks[[i]] <- ks[[i]][,-2]
 colnames(ks[[i]]) <- c("Sample", paste0("Q", 1:(ncol(ks[[i]])-1)))
 ks[[i]] <- gather(ks[[i]],"Pop","Value",2:ncol(ks[[i]]))
 ks[[i]]$Sample <- factor(ks[[i]]$Sample, levels = unique(ks[[i]]$Sample))
 
 # Plotting
 ks[[i]] <- ggplot(ks[[i]]) +
   geom_col(aes(x=Sample, y=Value, fill=Pop), width = 1) +
   scale_fill_manual(values = c('#66c2a5','#fc8d62','#8da0cb','#e78ac3','#a6d854')) +
   scale_y_continuous(expand = c(0, 0)) +
   labs(y = "") +
   theme_minimal() +
   theme(axis.text.x = element_blank(),
         axis.title.x = element_blank(),
         strip.text.x = element_blank(),
         text = element_text(family = "serif"),
         legend.position = "none")
}
  
# Now we will plot the Evanno results of maximum likelihood
likelihood <- read.delim("../03_Harvester/evannoTable.tab", header = F, comment.char = "#")

# Keeping only intersting columns
likelihood <- likelihood[,c(1,3,4)]
colnames(likelihood) <- c("K", "Mean", "SD")

# Plotting
plotA <- ggplot(likelihood) +
  geom_point(aes(x=K, y=Mean)) +
  geom_errorbar(aes(x=K, ymax=Mean+SD, ymin=Mean-SD)) +
  labs(y="LnP(K)", title = "A") +
  scale_y_continuous(n.breaks = 6) +
  theme_classic() +
  theme(text = element_text(family = "serif"),
        legend.position = "none")

# Printing
png("02_Structure.png", width = 1800, height = 1600, res = 300)
grid.arrange(plotA, ks$k2, ks$k3, ks$k4, ks$k5, heights=c(2,1,1,1,1), ncol = 1)
dev.off()
