rm(list = ls())

# Calling libraries
library(ggplot2)
library(tidyr)
library(gridExtra)

# Reading input file
k2 <- read.table("01_No_Priors_run_10_q", header = F, sep = " ")

# Ordering columns
k2 <- k2[,c(2,1,3,4)]

# Sorting dataframe
k2 <- k2[order(k2$V3, decreasing = T),-1]

# Changing colnames and tidying
colnames(k2) <- c("Sample","Q1","Q2")
k2 <- gather(k2,"Pop","Value",2:3)
k2$Sample <- factor(k2$Sample, levels = unique(k2$Sample))

# Plotting
plotB <- ggplot(k2) +
  geom_col(aes(x=Sample, y=Value, fill=Pop), width = 1) +
  scale_fill_manual(values = c("#fdc086", "#7fc97f")) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(y = "Q admixture", title = "B") +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        text = element_text(family = "serif"),
        legend.position = "none")

# Now we will plot the Evanno results of maximum likelihood
likelihood <- read.delim("evannoTable.tab", header = F, comment.char = "#")

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
png("Structure.png", width = 1800, height = 1600, res = 300)
grid.arrange(plotA, plotB, nrow = 2)
dev.off()
