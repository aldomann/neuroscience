# Simulation of the dynamics of neuronal ensembles using the model of FREs and QIF neurons
# Code developed by Alfredo Hernández and Cristian Estany

library(tidyverse)
library(data.table)
library(GGally)

# Calculations ---------------------------------------------

sys.time.init <- Sys.time()

# Compile C++ file if needed
compile = F
if (compile == T) {
	system("cd cpp; g++ -o run_solve qif_solve.cpp; ./run_solve")
}

# Read QIF data files and create data frames
read_qif_data <- function(){
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

read_raster_data <- function(){
	# Read raw data
	raster.data <- fread("cpp/raster.dat", header = F)
	# Clean data frame
	raster.data <- raster.data %>%
		rename(time = V1 , neuron = V2)
	return(raster.data)
}

qif.data <- read_qif_data()
raster.data <- read_raster_data()

sys.time.comp.final <- Sys.time()

# Simulate neurons via FREs
get_fre_data <- function(){
	source("fre_vs_qif_test.R")
}

get_fre_data()
out.fre.qif <- out.fre
out.fre.qif$v.avg <- qif.data$v.avg
out.fre.qif$r.avg <- qif.data$r.avg

sys.time.fre.final <- Sys.time()

# Data visualisation ---------------------------------------

get_plot_qif <- function(){
	ggplot(qif.data)+
		geom_line(mapping = aes(y = v.avg, x = seq(1, length(v.avg))),
							colour = "darkorange") +
		labs(x = "Time (s)", y = "v")
}

get_plots <- function(){
	plot_vt <- ggplot(out.fre.qif)+
		geom_line(aes(x = time, y = v.avg), colour = "black") +
		geom_line(aes(x = time, y = v), colour = "darkorange") +
		labs(x = "Time (s)", y = "v")

	plot_rt <- ggplot(out.fre.qif)+
		geom_line(aes(x = time, y = r.avg), colour = "black") +
		geom_line(aes(x = time, y = r), colour = "darkorange") +
		labs(x = "Time (s)", y = "r")

	plot_curr <- ggplot(current)+
		geom_line(mapping = aes(x = times, y = I)) +
		labs(x = "Time (s)", y = "I(t)")

	plot_raster <- ggplot(raster.data) +
		geom_point(aes(x = time, y = neuron), colour = "black", size = 0.2) +
		expand_limits(x = 0) +
		labs(x = "Time (s)", y = "Neuron index")

	pm <- ggmatrix(list(plot_rt, plot_vt, plot_raster, plot_curr),
								 nrow = 4, ncol = 1,
								 yAxisLabels = c("r", "v", "Neuron index", "I(t)"),
								 xlab = "Time (s)") +
		theme( #strip.background = element_rect(fill = "white"),
			strip.placement = "outside")
	pm
}

# Figure 3b
plot_rv_trajectory <- function(data){
	ggplot(data)+
		geom_path(mapping = aes(x = r.avg, y = v.avg), colour = "black", size = 0.3) +
		geom_path(mapping = aes(x = r, y = v), colour = "darkorange", size = 0.9) +
		labs(x = "r", y = "v")
}

get_plots()
plot_rv_trajectory(out.fre.qif)

sys.time.final <- Sys.time()

# Print compilation times
sys.time.comp.final - sys.time.init
sys.time.fre.final - sys.time.comp.final
sys.time.final - sys.time.init
