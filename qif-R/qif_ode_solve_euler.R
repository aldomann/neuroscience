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
# Figure 2 parameters
# parms <- c(delta = 1,   # lorentzian_halfwidth
# 					 etabar = -5, # intrinsec_current
# 					 J = 15)      # syn_weight

# ODE Calculation ------------------------------------------

# Current function
get_current <- function(mode, h = 1e-4, I0, omega = pi, t.imp.init = 0, t.final, t.imp.final = t.final){
	times = seq(from = -1, to = t.final, by = h)
	if(mode == "square")
		current <- data.frame(times) %>%
			mutate(I = rep(I0, length(times))) %>% # Constant current
			mutate(I = ifelse(times <= t.imp.init, 0, I)) %>% # Initial condition
			mutate(I = ifelse(times >= t.imp.final, 0, I))# Final condition
	else if(mode == "sin")
		current <- data.frame(times) %>%
			mutate(I = I0*sin(omega*times)) %>% # Sinisoidal current
			mutate(I = ifelse(times <= t.imp.init, 0, I)) # Initial condition
	return(current)
}

## Euler Method
euler <- function(f, h = 1e-4, t.init, v0, vp, t.final) {
	N = (t.final - t.init) / h
	t = v = spike = s = numeric(N + 1)
	t[1] = t.init; v[1] = v0
	vr = -vp
	refractory_time = 2/vp
	refractory_steps = refractory_time / h
	tau_time = 1e-3
	tau_steps = tau_time / h

	i = 1
	while (i <= N) {
		if(v[i] >= vp){ # Spike reset
			spike[i] = 1
			if(spike[i] == 1){ # Synaptic activation
				for(j in 0:tau_steps){
					if(i + j >= N){
						break
					}
					else{
						s[i + j] = 2
					}
				}
			}
			for(j in 1:refractory_steps){ # Refractory time in v
				v[i + 1] = vr
				t[i + 1] = t[i] + h
				i = i + 1
			}
		}
		else{ # Normal evolution
			v[i + 1] = v[i] + h * f(t[i], v[i], current$I[i], s[i])
			t[i + 1] = t[i] + h
			i = i + 1
		}

	}
	return (data.frame(time = t, v = v, spike = spike, s = s))
}
## End of the function

delta <- 1
etabar <- 4
eta <- rcauchy(1, location = etabar, scale = delta)

# Different current distributions
# current <- get_current("square", I0 = 3, t.imp.init = 0, t.final = 6, t.imp.final = 5)
current <- get_current("sin", I0 = 1, omega = 2*pi, t.imp.init = 0, t.final = 6)

f <- function(t, v, s, current){v^2 + eta + current}
out.qif <- euler(f, h = 1e-4, v0 = -2, vp = 100, t.init = -1, t.final = 6)
# print(system.time(out.qif <- euler(f, h = 1e-4, t.init = 0, v0 = -2, vp = 100, t.final = 5)))


# Data visualisation ---------------------------------------

# Figure 2 (no r)
# plot_vit <- function(data, current){
# 	plot_vt <- ggplot(data)+
# 		geom_line(mapping = aes(x = time, y = v),
# 							colour = "darkorange") +
# 		labs(x = "Time (s)", y = "v")
#
# 	plot_curr <- ggplot(current)+
# 		geom_line(mapping = aes(x = times, y = I)) +
# 		labs(x = "Time (s)", y = "I(t)")
#
# 	layout <- matrix(c(1,2), nrow = 2, byrow = TRUE)
# 	multiplot(plotlist = list(plot_vt, plot_curr), layout = layout)
# }

# plot_vit(out.qif, current)

# Plot of v, s(t), I(t)
plot_vits <- function(data, current){
	plot_vt <- ggplot(data)+
		geom_line(mapping = aes(x = time, y = v),
							colour = "darkorange") +
		labs(x = "Time (s)", y = "v")

	plot_st <- ggplot(data)+
		geom_line(mapping = aes(x = time, y = s)) +
		labs(x = "Time (s)", y = "s(t)")

	plot_curr <- ggplot(current)+
		geom_line(mapping = aes(x = times, y = I)) +
		labs(x = "Time (s)", y = "I(t)")

	layout <- matrix(c(1,2,3), nrow = 3, byrow = TRUE)
	multiplot(plotlist = list(plot_vt, plot_st, plot_curr), layout = layout)
}

plot_vits(out.qif, current)
