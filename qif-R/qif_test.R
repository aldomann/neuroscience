# library(deSolve)
library(tidyverse)

h = 1
t.final = 10
t.init = 0
v0 = 1
vp = 100

neuron.list = list()
max.neurons = 2
N = (t.final - t.init) / h
for(k in 1:max.neurons){ # Initialise the neurons
	neuron.list[[k]] = data.frame(t = numeric(N + 1), v = numeric(N + 1), spike = numeric(N + 1), s = numeric(N + 1))
	neuron.list[[k]]$t[1] = t.init
	neuron.list[[k]]$v[1] = v0
}

# N = (t.final - t.init) / h
# t = v = spike = s = numeric(N + 1)
# t[1] = t.init; v[1] = v0

vr = -vp
refractory_time = 2/vp
refractory_steps = refractory_time / h
tau_time = 1e-3
tau_steps = tau_time / h

i = 1
while (i <= N) { # Start of time step loop

	if(neuron.list[[k]]$v[i] >= vp){ # Spike reset
		neuron.list[[k]]$spike[i] = 1
		if(neuron.list[[k]]$spike[i] == 1){ # Synaptic activation
			for(j in 0:tau_steps){
				if(i + j >= N){
					break
				}
				else{
					neuron.list[[k]]$s[i + j] = 2
				}
			}
		}
		for(j in 1:refractory_steps){ # Refractory time in v
			neuron.list[[k]]$v[i + 1] = vr
			neuron.list[[k]]$t[i + 1] = t[i] + h
			i = i + 1
		}
	}
	else{ # Normal evolution
		for(k in 1:max.neurons){
			neuron.list[[k]]$v[i + 1] = v[i] + h + 1 #* f(neuron.list[[k]]$t[i], neuron.list[[k]]$v[i], current$I[i], s[i])
			neuron.list[[k]]$t[i + 1] = t[i] + h
		}
		i = i + 1
	}

} # End of time step loop
