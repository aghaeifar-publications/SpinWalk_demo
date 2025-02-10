import os
import pickle
import numpy as np
import matplotlib.pyplot as plt
import time

from disimpy import gradients, simulations, substrates, utils
from disimpy.gradients import GAMMA

n_walkers = int(1e6)  # number of random walkers
n_t = int(1e5)  # number of time points
diffusivity = 1e-9  # in SI units (m^2/s)


gradient = np.zeros((1, 500, 3))
gradient[0, 1:249, 0] = 1
gradient[0, -249:-1, 0] = -1
T = 70e-3
dt = T / (gradient.shape[1] - 1)
gradient, dt = gradients.interpolate_gradient(gradient, dt, n_t)
bs = np.linspace(100, 10000, 100)
gradient = np.concatenate([gradient for _ in bs], axis=0)
gradient = gradients.set_b(gradient, dt, bs)


substrate = substrates.free()

start_time = time.time()

signals = simulations.simulation(n_walkers, diffusivity, gradient, dt, substrate, quiet=True)

end_time = time.time()
elapsed_time = end_time - start_time
print(f"Elapsed time: {elapsed_time} seconds")




