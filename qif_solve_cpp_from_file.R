library(tidyverse)
library(data.table)
# library(Rcpp)

# Calculations ---------------------------------------------

# sourceCpp("cpp/qif_solve_simple_ask.cpp")

v.qif <- t(fread("cpp/v_avg.dat", header = F))
v.qif <- v.qif[-nrow(v.qif),] # Remove last row
v.qif <- data.frame(v.avg = v.qif)

source("fre_vs_qif_test.R")

# Data visualisation ---------------------------------------

# ggplot(v.qif)+
# 	geom_line(mapping = aes(y = v.avg, x = seq(1, length(v.avg))),
# 						colour = "darkorange") +
# 	labs(x = "Time (s)", y = "v")

out.fre.qif <- out.fre
out.fre.qif$v.agv <- v.qif$v.avg

ggplot(out.fre.qif)+
	geom_line(mapping = aes(x = time, y = v.agv), colour = "black") +
	geom_line(mapping = aes(x = time, y = v), colour = "darkorange") +
	labs(x = "Time (s)", y = "v")
