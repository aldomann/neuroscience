library(tidyverse)
library(reshape2)

etabar <- 5
N <- 10000
eta <- c()
Delta <- 1

for(j in 1:N){
	eta[j] <- etabar + Delta * 1/tan(pi/2 * (2*j - N -1)/(N + 1))
}

eta.m <- melt(eta)
ggplot(eta.m, aes(x=seq_along(value),y=value)) +
	geom_point(stat="identity")

ggplot(eta.m, aes(value)) +
	geom_histogram(bins = 200)
