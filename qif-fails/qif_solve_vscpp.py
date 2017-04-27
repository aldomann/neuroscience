from random import random
from math import tan

pi = 3.14159

neurons = 10**8

# Generate eta
eta = []
for n in range(neurons):
		eta.append(tan(pi*(random() - 1/2 )) - 5)
