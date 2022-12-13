#Script para visualizar distribuciones previas y generar archivo de entrada "init_v_file" para MSVAR
#Limpieza
rm(list = ls())

# librerias
library(dplyr)
library(ggplot2)

#Numero de micros
micros <- 8

# Ploidia
ploidy <- 2

# Tiempo generacional (i. e. 4 años por generación)
gen <- 4

# Se actulizaran en cada iteracion los valores iniciales de la MCMC (0 = SI, 1 = NO); Se recomienda SI
act <- 0

# Crecimiento lineal o exponencial (lineal=0, exponencial=1)
crec <- 1

# Longitud MCMC (total de iteraciones muestreadas)
MCMC <- 10000

# Thinning (iteraciones desechadas entre ellas)
thin <- 10000

# Total de longitud de la MCMC
MCMC * thin

# Parametros generales ####
#Estableciendo previas
# Ne
ne <- 4200
ne.sd <- 2000
ne <- data.frame(parameter="Ne", mean=ne, sd=ne.sd)

# Mu [Una sd de 10 es muy grande para una media de 0.0005, PERO msvar no acpeta lognormal negativa, i. e., menor a 1]
mu <- 0.0005
mu.sd <- 10
mu <- data.frame(parameter="Mu", mean=mu, sd=mu.sd)

# t (en generaciones)
t <- 11600
t.sd <- 4000
t <- data.frame(parameter="t", mean=t, sd=t.sd)

# Model
priors <- rbind(ne, mu, t)
rm(ne, ne.sd, mu, mu.sd, t, t.sd)

# Estimating log10
priors$logmean <- log10(priors$mean)
priors$logsd <- log10(priors$sd)

# Limites distribucion normal
priors$liminfnorm <- priors$mean - 5*priors$sd
priors$limsupnorm <- priors$mean + 5*priors$sd

# Longitud de la curva de probabilidad
longitud <- 100000

# Visualización de distribuciones mediante normal
xnorm <- list()
ynorm <- list()
for (i in priors$parameter) {
  xnorm[[i]] <- seq(priors[priors$parameter==i,"liminfnorm"], 
                    priors[priors$parameter==i,"limsupnorm"], 
                    length=longitud)
  ynorm[[i]] <- dnorm(xnorm[[i]], 
                      mean=priors[priors$parameter==i,"mean"], 
                      sd=priors[priors$parameter==i,"sd"])
  xnorm[[i]] <- data.frame(parameter=i, x=xnorm[[i]])
  ynorm[[i]] <- data.frame(parameter=i, y=ynorm[[i]])
}

# Merging dataframes
xnorm <- bind_rows(xnorm)
ynorm <- bind_rows(ynorm)
norms <- cbind(xnorm, y=ynorm$y)
rm(xnorm, ynorm)

# Plotting
png("Priors_Normal.png",width = 1600, height = 1000, res = 300)
ggplot(norms) +
  facet_wrap(~parameter, scales = "free_y", ncol = 1) +
  scale_x_continuous(n.breaks = 10) +
  geom_polygon(aes(x=x, y=y, fill=parameter), color="black") +
  theme_classic() +
  theme(legend.position = "none",
        axis.title = element_blank())
dev.off()

# Escenarios previos ####
escenarios <- priors[1,c(1:3)]
escenarios[1,1] <- "Stability"

# Expansion
na1 <- 1500
na1.sd <- 1500
na1 <- data.frame(parameter="Expansion", mean=na1, sd=na1.sd)

# Reducción
na2 <- 8000
na2.sd <- 2000
na2 <- data.frame(parameter="Reduction", mean=na2, sd=na2.sd)

# Model
escenarios <- rbind(escenarios, na1, na2)
rm(na1, na1.sd, na2, na2.sd)

# Estimating log10
escenarios$logmean <- log10(escenarios$mean)
escenarios$logsd <- log10(escenarios$sd)

# Limites distribucion normal
escenarios$liminfnorm <- escenarios$mean - 5*escenarios$sd
escenarios$limsupnorm <- escenarios$mean + 5*escenarios$sd

# Visualización de distribuciones mediante normal
xnorm <- list()
ynorm <- list()
for (i in escenarios$parameter) {
  xnorm[[i]] <- seq(escenarios[escenarios$parameter==i,"liminfnorm"], 
                    escenarios[escenarios$parameter==i,"limsupnorm"], 
                    length=longitud)
  ynorm[[i]] <- dnorm(xnorm[[i]], 
                      mean=escenarios[escenarios$parameter==i,"mean"], 
                      sd=escenarios[escenarios$parameter==i,"sd"])
  xnorm[[i]] <- data.frame(parameter=i, x=xnorm[[i]])
  ynorm[[i]] <- data.frame(parameter=i, y=ynorm[[i]])
}

# Merging dataframes
xnorm <- bind_rows(xnorm)
ynorm <- bind_rows(ynorm)
norms <- cbind(xnorm, y=ynorm$y)
rm(xnorm, ynorm)

# Factoring
norms$parameter <- factor(norms$parameter, levels = c("Expansion", "Stability","Reduction"))

# Plotting
png("Escenarios_Normal.png",width = 1600, height = 1000, res = 300)
ggplot(norms) +
  scale_x_continuous(n.breaks = 10) +
  geom_polygon(aes(x=x, y=y, fill=parameter), color="black", alpha=0.5) +
  labs(x="Na", y="Density") +
  theme_classic() +
  theme(legend.position = "none",
        text = element_text(family = "serif"))
dev.off()
rm(norms)

#Generando archivo de entrada initfile ####
# Setting seed for replication
set.seed(123)

# Generating files
for (i in 1:3) {
  dir.create(paste0("../0",i,"_",escenarios[i,1]), showWarnings = F, recursive = T)

# Sinking to text file
sink(paste0("../0",i,"_",escenarios[i,1],"/init_v_file"), split = T)

# Numero aleatorio para usarse como random seed
cat(runif(1, 1, 9999999),"\n")

# Ploidia
cat(ploidy,"\n")

# Tiempo generacional
cat(gen,"\n")

# Puntos de inicio para Ne
cat(formatC(abs(rnorm(micros, mean=priors[1,2], sd=priors[1,3])), format = "E", digits = 2),"\n")

# Puntos de inicio para Na (for loop)
cat(formatC(abs(rnorm(micros, mean=escenarios[i,2], sd=escenarios[i,3])), format = "E", digits = 2),"\n")

# Puntos de inicio para mu [la desviacion es tan grande que suele tomar mutaciones iniciales muy grandes, usaremos la misma media como sd]
cat(formatC(abs(rnorm(micros, mean=priors[2,2], sd=priors[2,2])), format = "E", digits = 2),"\n")

# Puntos de inicio para t
cat(formatC(abs(rnorm(micros, mean=priors[3,2], sd=priors[3,3])), format = "E", digits = 2),"\n")

# ¿Se actualizaran los valores? (0=SI, 1=NO)
cat(rep(act, 4),"\n")

# Distribución log normal Ne
cat(paste0(round(priors[1,c(4,5)], 2)),"\n")

# Distribución log normal Na (for loop)
cat(paste0(round(escenarios[i,c(4,5)], 2)),"\n")

# Distribución log normal Mu
cat(paste0(round(priors[2,c(4,5)], 2)),"\n")

# Distribución log normal t
cat(paste0(round(priors[3,c(4,5)], 2)),"\n")

# Hiper-previa Ne
cat(paste0(round(priors[1,c(4,5)], 2)),"0 0.5\n")

# Hiper-previa Na (for loop)
cat(paste0(round(escenarios[i,c(4,5)], 2)),"0 0.5\n")

# Hiper-previa Mu
cat(paste0(round(priors[2,c(4,5)], 2)),"0 0.5\n")

# Hiper-previa t
cat(paste0(round(priors[3,c(4,5)], 2)),"0 0.5\n")

# Crecimiento lineal o exponencial
cat(crec,"\n")

# MCMC params
cat(MCMC,"\n")
cat(thin)
sink()

# Copying microsats data file and msvar
file.copy("../01_Curvina_NoNulls-MSVAR.txt", paste0("../0",i,"_",escenarios[i,1],"/infile"))
file.copy("../msvar1.3.exe", paste0("../0",i,"_",escenarios[i,1],"/msvar1.3.exe"))
file.copy("../INTFILE", paste0("../0",i,"_",escenarios[i,1],"/INTFILE"))
}
