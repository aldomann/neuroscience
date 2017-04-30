library(stats)
library(ggplot2)
# x<-seq(-10,10,by=0.1)
# dcauchy(x, l = -5, s = 1)

# x<-seq(-10,5,by=0.1)
# lines(x, rcauchy(x, location = -5, scale = 1),col="blue")
dist <- rcauchy(1000, location = -5, scale = 1)
ggplot() +
	geom_histogram(aes(dist), bins = 2000)

dist2 <- tan(pi*(runif(1000,0,1) - 1/2 )) - 5

print(system.time(dist <- rcauchy(300, location = -5, scale = 1)))
print(system.time(dist2 <- tan(pi*(runif(300,0,1) - 1/2 )) - 5))

ggplot() +
	geom_histogram(aes(dist2), binwidth = 0.1)
