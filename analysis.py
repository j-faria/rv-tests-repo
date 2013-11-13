from numpy import *
from matplotlib.pylab import *

path = 'chains/'
root = path + 'gaussian-'

file1 = root + 'phys_live.points'
P, K, ecc, w, t0 = loadtxt(file1, usecols=(0,1,2,3,4), unpack=True)

subplot(151)
hist(P)
xlabel('P')

subplot(152)
hist(K)
xlabel('K')

subplot(153)
hist(ecc)
xlabel('ecc')

subplot(154)
hist(w)
xlabel('w')

subplot(155)
hist(t0)
xlabel('t0')
show()