# Using this script we will edit hpars.dat files to get them ready for tracer
hpars <- list()

for (i in c("01_Stability","02_Expansion","03_Reduction")) {
  hpars[[i]] <- read.table(paste0("../",i,"/hpars.dat"), sep=" ", header=F)
  colnames(hpars[[i]]) <- c("State","Muts","LogL","Ne_Mean","Ne_SD","Na_Mean","Na_SD","Mu_Mean","Mu_SD","t_Mean","t_SD")
  write.table(hpars[[i]], paste0(i,".tsv"), sep = "\t", quote = F, row.names = F)
}