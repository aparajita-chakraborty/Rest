import numpy as np

x = np.load('../Pressure_analysis/eqnpt.Lbox.npy')
y = []
for i in range(1,11):
	y.append(x[i][-100:].mean())

z = np.asarray(y)

m = []
for i in range(1,11):
        m.append(x[i][-200:].mean())

z = np.asarray(y)
n = np.asarray(m)

print(f"For last 200 frames: {n.mean()}")
print(f"For last 100 frames: {z.mean()}")

