F2PYFLAGS = --f77exec="/home/joao/mesasdk/bin/gfortran" --f77flags="-O3 -Ofast"

all: get_rv1.so get_rvN.so
	
get_rv1.so: get_rv1.f90
	f2py -m get_rv1 -c $^ $(F2PYFLAGS)

get_rvN.so: get_rvN.f90
	f2py -m get_rvN -c $^ $(F2PYFLAGS)

clean: 
	rm -f *.so