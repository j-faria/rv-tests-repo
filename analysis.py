from numpy import *
from matplotlib.pylab import *

from get_rvN import get_rvn 	# n planets

path = 'chains/'
root = path + 'nest-'

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


#####################################################################
with open('chains/nest-stats.dat', 'r') as f:
	par_file = f.readlines()
npar = int(par_file[-1].strip()[0])
print '# of parameters: ', npar
pars = [float(par_file[-i].split()[1]) for i in range(1,npar+1)]
pars.reverse()
t, v, err = loadtxt('14her.rv', unpack=True)
vel = zeros_like(t)
get_rvn(t, pars[0], pars[1], pars[2], pars[3], pars[4], pars[5], vel)

figure()
errorbar(t, v, yerr=err, fmt='o')
plot(t, vel, 'r-')
show()