# This is code to replicate the model of QIF neurons.
# Code developed by Alfredo Hernández and Cristian Estany

# How to use multiplots:
# http://rstudio-pubs-static.s3.amazonaws.com/2852_379274d7c5734f979e106dcf019ec46c.html
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/

# rm(list = ls())

library(deSolve)
library(tidyverse)
# source("http://peterhaschke.com/Code/multiplot.R")
source("multiplot.R")

# Function and parameters definition -----------------------

# Function to solve
my_function <- function(t, state, parms, input) {
	with(as.list(c(state, parms)), {
		eta <- rcauchy(1, location = etabar, scale = delta)
		I <- input(t) # Input current
		dv <- v^2# + I # Membrane potential
		list(c(dv))
	})
}

# Figure 2 parameters
parms <- c(delta = 1,   # lorentzian_halfwidth
					 etabar = -5, # intrinsec_current
					 J = 15)      # syn_weight

init_state <- c(v = -100)
times <- seq(from = -10, to = 100, by = 0.01)

# Current function
get_current <- function(mode, I0, omega, ti, tf){
	if(mode == "square")
		current <- data.frame(times) %>%
			dplyr::mutate(I = rep(I0, length(times))) %>% # Constant current
			dplyr::mutate(I = ifelse(times <= ti, 0, I)) %>% # Initial condition
			dplyr::mutate(I = ifelse(times >= tf, 0, I))# Final condition
	else if(mode == "sin")
		current <- data.frame(times) %>%
			dplyr::mutate(I = I0*sin(omega*times)) %>% # Sinisoidal current
			dplyr::mutate(I = ifelse(times <= ti, 0, I)) # Initial condition
	return(current)
}

# Different current distributions
# current <- get_current("square", 3, pi, 0, 30)
current <- get_current("sin", 3, pi/20, 0, 30)

curr_imp <- approxfun(current$times, current$I, rule = 2)

# ODE Calculation ------------------------------------------

out <- as.data.frame(ode(y = init_state, times = times,
					 func = my_function, parms = parms, input = curr_imp,
					 method = "rk4"))

# Data visualisation ---------------------------------------

# Figure 2 (no r)
plot_vit <- function(data, current){
	plot_vt <- ggplot(data)+
		geom_line(mapping = aes(x = time, y = v),
							colour = "darkorange") +
		labs(x = "Time (s)", y = "v")

	plot_curr <- ggplot(current)+
		geom_line(mapping = aes(x = times, y = I)) +
		labs(x = "Time (s)", y = "I(t)")

	layout <- matrix(c(1,2), nrow = 2, byrow = TRUE)
	multiplot(plotlist = list(plot_vt, plot_curr), layout = layout)
}

plot_vit(out, current)
