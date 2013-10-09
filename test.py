from get_rv1 import get_rv 		# 1 planet
from get_rvN import get_rvn 	# n planets

from numpy import *


times = linspace(2449460, 2452860, 100)
vel1 = zeros_like(times)
vel2 = zeros_like(times)

get_rv(times, 1425, 10, 0.9, 0.2, 2452000, vel1)
get_rvn(times, [1425, 13], [10, 3], [0.9, 0.02], [0.2, 0.3], [2452000, 2451000], 0., vel2)

savetxt('test/out_test.txt', zip(times, vel1, vel2))