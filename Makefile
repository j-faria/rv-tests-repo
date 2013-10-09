F2PYFLAGS = --f77exec="/home/joao/mesasdk/bin/gfortran" --f77flags="-O3 -Ofast"

get_rv1.so: get_rv1.f90
	f2py -m get_rv1 -c $^ $(F2PYFLAGS)


clean: 
	rm -f *.so