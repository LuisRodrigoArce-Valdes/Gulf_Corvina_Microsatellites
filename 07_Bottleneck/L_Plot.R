rm(list = ls())
library(ggplot2)

# Reading data file
Ls <- read.delim("3_Ls.txt", header = F)

# transposing
Ls <- as.data.frame(t(Ls))
row.names(Ls) <- 1:nrow(Ls)
colnames(Ls) <- c("Allelic_class","Frequency")
Ls$Frequency <- as.numeric(Ls$Frequency)
Ls$Allelic_class <- gsub("-"," - ", Ls$Allelic_class)

# Plotting
png("L.png", width = 1600, height = 1200, res = 300)
ggplot(Ls) +
  geom_col(aes(x=Allelic_class, y=Frequency), fill="black") +
  scale_y_continuous(limits = c(0,1), n.breaks = 5) +
  labs(x="Allelic class") +
  theme_classic() +
  theme(text = element_text(family = "serif"))
dev.off()
