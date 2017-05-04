library(tidyverse)
library(data.table)

# Calculations ---------------------------------------------

sys.time.init <- Sys.time()

# Compile C++ file if needed
# This won't work for C++ cin inputs (or of any kind, I would imagine)
compile = T
if (compile == T) {
	system("cd cpp; g++ -o run_solve qif_solve.cpp; ./run_solve")
}

read_qif.data <- function(){ # Manually select data file
	v.qif <- t(fread("cpp/v_avg.dat", header = F))
	v.qif <- v.qif[-nrow(v.qif),] # Remove last row
	v.qif <- data.frame(v.avg = v.qif)
	return(v.qif)
}

v.qif <- read_qif.data()

get_fre.data <- function(){
	source("fre_vs_qif_test.R")
}

# Data visualisation ---------------------------------------

get_vplot <- function(plot.type = "qif"){
	if (plot.type == "qif") { # Just QIF plot
		ggplot(v.qif)+
			geom_line(mapping = aes(y = v.avg, x = seq(1, length(v.avg))),
								colour = "darkorange") +
			labs(x = "Time (s)", y = "v")
	}
	else if (plot.type == "fre+qif") { # Comparison with FRE model
		get_fre.data()
		out.fre.qif <- out.fre
		out.fre.qif$v.agv <- v.qif$v.avg

		ggplot(out.fre.qif)+
			geom_line(mapping = aes(x = time, y = v.agv), colour = "black") +
			geom_line(mapping = aes(x = time, y = v), colour = "darkorange") +
			labs(x = "Time (s)", y = "v")
	}
}

# get_vplot()
get_vplot(plot.type = "fre+qif")

sys.time.final <- Sys.time()

sys.time.final - sys.time.init
