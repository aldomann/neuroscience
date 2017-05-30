# Simulation to replicate the model of neurons using FREs
# Code developed by Alfredo Hernández and Cristian Estany

# How to use multiplots:
# http://rstudio-pubs-static.s3.amazonaws.com/2852_379274d7c5734f979e106dcf019ec46c.html
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/

library(deSolve)
library(tidyverse)
library(GGally)
# source("http://peterhaschke.com/Code/multiplot.R")
source("multiplot.R")

# Function and parameters definition -----------------------

# Function to solve
my_function <- function(t, state, parms, input) {
	with(as.list(c(state, parms)), {
		I <- input(t) # Input current
		dr <- delta/pi + 2 * r * v # Fire ratio
		dv <- v^2 + etabar + J * r + I - pi^2 * r^2 # Membrane potential
		list(c(dr, dv))
	})
}

# Figure 2 parameters
parms <- c(delta = 1,   # lorentzian_halfwidth
					 etabar = -5, # intrinsec_current
					 J = 15)      # syn_weight

# Figure 3 parameters
# parms <- c(delta = 1,   # lorentzian_halfwidth
# 					 etabar = -2.5, # intrinsec_current
# 					 J = 10.5)       # syn_weight

init_state <- c(r = 0, v = -2)
times <- seq(from = -10, to = 40, by = 0.01)
# times <- seq(from = -10, to = 80, by = 0.01)

# Current function
get_current <- function(mode, I0, omega, t.init, t.final){
	if(mode == "square")
		current <- data.frame(times) %>%
			mutate(I = rep(I0, length(times))) %>% # Constant current
			mutate(I = ifelse(times <= t.init, 0, I)) %>% # Initial condition
			mutate(I = ifelse(times >= t.final, 0, I))# Final condition
	else if(mode == "sin")
		current <- data.frame(times) %>%
			mutate(I = I0*sin(omega*times)) %>% # Sinisoidal current
			mutate(I = ifelse(times <= t.init, 0, I)) # Initial condition
	return(current)
}

# Different current distributions
current <- get_current("square", I0 = 3, t.init = 0, t.final = 30)
# current <- get_current("sin", I0 = 3, omega = pi/20, t.init = 0, t.final = 80)

curr_imp <- approxfun(current$times, current$I, rule = 2)

# ODE Calculation ------------------------------------------

out.fre <- as.data.frame(ode(y = init_state, times = times,
					 func = my_function, parms = parms, input = curr_imp,
					 method = "rk4"))

# Data visualisation ---------------------------------------

# Figure 2
plot_rvit <- function(data, current){
	plot_rt <- ggplot(data)+
		geom_line(mapping = aes(x = time, y = r),
							colour = "darkorange") +
		labs(x = "Time (s)", y = "r")

	plot_vt <- ggplot(data)+
		geom_line(mapping = aes(x = time, y = v),
							colour = "darkorange") +
		labs(x = "Time (s)", y = "v")

	plot_curr <- ggplot(current)+
		geom_line(mapping = aes(x = times, y = I)) +
		labs(x = "Time (s)", y = "I(t)")

	# layout <- matrix(c(1,2,3), nrow = 3, byrow = TRUE)
	# multiplot(plotlist = list(plot_rt, plot_vt, plot_curr), layout = layout)
	pm <- ggmatrix(list(plot_rt, plot_vt, plot_curr),
								 nrow = 3, ncol = 1,
								 yAxisLabels = c("r", "v", "I(t)"),
								 xlab = "Time (s)") +
		theme( #strip.background = element_rect(fill = "white"),
			strip.placement = "outside")
	pm
}

# Figure 3b
plot_rv_trajectory <- function(data){
	ggplot(data)+
		geom_path(mapping = aes(x = r, y = v),
							colour = "darkorange") +
		labs(x = "r", y = "v")
}

plot_rvit(out.fre, current)
# plot_rv_trajectory(out.fre)
