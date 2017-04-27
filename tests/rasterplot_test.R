library(tidyverse)
library(raster)

df1 <- data.frame(time = c(1,2,3,1,2,3), neuron = c(1,1,1, 2,2,2), r = c(0.8,0.5,1, 0.2,0.4,0.8))

ggplot(df1) +
	geom_raster(aes(x = time, y = neuron, fill = r))

df2 <- data.frame( time = c(1, 2, 3), r1 = c(0.2, 0.3, 0.4), r2 = c(0.7, 0.9, 0.5))
