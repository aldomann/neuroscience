from random import random
from math import tan

pi = 3.14159

# Initial time
t_final = 2.0
t_init = 0.0

v0 = -2
vp = 100.0

# neurons = 10**2
neurons = 10**4
h = 0.01
steps = int((t_final - t_init)/h)

# Initialize matrices
v = [[0 for i in range(steps+1)] for n in range(neurons)]
I = [3 for i in range(steps+1)]

# Generate eta
# eta = [-5 for i in range(neurons)] # Just etabar
eta = []
for n in range(neurons):
		eta.append(tan(pi*(random() - 1/2 )) - 5)

# Initialize neurons
for n in range(neurons):
	v[n][0] = v0

for i in range(1,steps+1):
	# print(i) # To see if it really works
	for n in range(neurons):
		if v[n][i-1] >= vp:
			v[n][i] = -vp
		else:
			v[n][i] = v[n][i-1] + h * (v[n][i-1]**2 + I[i] + eta[n])

v_avg = [0 for i in range(steps+1)]
for i in range(0, steps+1):
	v_avg[i] = sum(row[i] for row in v)/neurons
