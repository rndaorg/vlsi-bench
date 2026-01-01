import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt('vtc_data.txt')
vin, vout = data[:,0], data[:,1]
plt.plot(vin, vout)
plt.xlabel('Vin (V)'); plt.ylabel('Vout (V)')
plt.title('CMOS Inverter VTC')
plt.grid()
plt.show()