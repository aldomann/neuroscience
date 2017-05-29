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
					 # J = 0)      # syn_weight

init_state <- c(r = 0, v = -2)
times <- seq(from = 0, to = 5, by = 0.0001)

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
current <- get_current("square", I0 = 3, t.init = 0, t.final = 5)
# current <- get_current("sin", I0 = 3, omega = pi/20, t.init = 0, t.final = 10)

curr_imp <- approxfun(current$times, current$I, rule = 2)

# ODE Calculation ------------------------------------------

out.fre <- as.data.frame(ode(y = init_state, times = times,
					 func = my_function, parms = parms, input = curr_imp,
					 method = "rk4"))
