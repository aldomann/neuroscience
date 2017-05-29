# Simulation of the dynamics of neuronal ensembles using the model of FREs and QIF neurons
# Code developed by Alfredo Hernández and Cristian Estany

library(tidyverse)
library(data.table)

# Calculations ---------------------------------------------

sys.time.init <- Sys.time()

# Compile C++ file if needed
compile = T
if (compile == T) {
	system("cd cpp; g++ -o run_solve qif_solve.cpp; ./run_solve")
}

read_qif_data <- function(){ # Manually select data file
	# Read raw data
	v.data <- t(fread("cpp/v_avg.dat", header = F))
	r.data <- t(fread("cpp/r_avg.dat", header = F))
	# Remove last rows
	v.data <- v.data[-nrow(v.data),]
	r.data <- r.data[-nrow(r.data),]
	# Create data frame
	qif.data <- data.frame(v.avg = v.data, r.avg = r.data)

	return(qif.data)
}

qif.data <- read_qif_data()

get_fre_data <- function(){
	source("fre_vs_qif_test.R")
}
sys.time.comp.final <- Sys.time()

# Data visualisation ---------------------------------------

get_plot_qif <- function(){
	ggplot(qif.data)+
		geom_line(mapping = aes(y = v.avg, x = seq(1, length(v.avg))),
							colour = "darkorange") +
		labs(x = "Time (s)", y = "v")
}

get_plots <- function(){
	get_fre_data()
	out.fre.qif <- out.fre
	out.fre.qif$v.agv <- qif.data$v.avg
	out.fre.qif$r.agv <- qif.data$r.avg

	plot_vt <- ggplot(out.fre.qif)+
		geom_line(mapping = aes(x = time, y = v.agv), colour = "black") +
		geom_line(mapping = aes(x = time, y = v), colour = "darkorange") +
		labs(x = "Time (s)", y = "v")

	plot_rt <- ggplot(out.fre.qif)+
		geom_line(mapping = aes(x = time, y = r.agv), colour = "black") +
		geom_line(mapping = aes(x = time, y = r), colour = "darkorange") +
		labs(x = "Time (s)", y = "r")

	layout <- matrix(c(1,2), nrow = 2, byrow = TRUE)
	multiplot(plotlist = list(plot_rt, plot_vt), layout = layout)
}

# get_plot_qif()
get_plots()

sys.time.final <- Sys.time()

sys.time.comp.final - sys.time.init
sys.time.final - sys.time.init
