# for compiling python extensions
FPY = f2py
F2PYFLAGS = --f90exec="/usr/bin/gfortran" --opt="-O3 -Ofast"
F2PYFLAGS += --f90flags="-w -Wno-unused-parameter -fPIC -ffree-line-length-none"

# for compiling Fortran
FC = gfortran
FFLAGS +=  -I. -O3 -w -Wno-unused-parameter -fPIC -ffree-line-length-none


# for MultiNest
NESTLIBDIR=/home/joao/Programs/MultiNest_v3.0/
LAPACKLIB = -llapack -L/usr/lib
LIBS = -L$(NESTLIBDIR) -lnest3 $(LAPACKLIB)
ifndef WITHOUT_MPI
# compiling with MPI support. 
# You can disable this with 
# $ make WITHOUT_MPI=1
FC = mpif90
FFLAGS += -DMPI
endif

MN_OBJ = params.o like.o nestwrap.o main.o likelihood.o get_rvN.o


all: gaussian get_rv1.so get_rvN.so

test: get_rv1.so get_rvN.so
	python test.py
	ndiff test/out_test.txt test/out_normal.txt -relerr 1.0e-5

get_rv1.so: get_rv1.f90
	$(FPY) -m get_rv1 -c $^ $(F2PYFLAGS)

get_rvN.so: get_rvN.f90 likelihood.f90
	$(FPY) -m get_rvN -c $^ $(F2PYFLAGS)


%.o %.mod: %.f90
	$(FC) $(FFLAGS) -I$(NESTLIBDIR)  $(LIBS) -c $*.f90
 
gaussian: $(MN_OBJ)
	$(FC) -o gaussian $(MN_OBJ) $(FFLAGS) $(LIBS)


main: main.f90 like.f90 nestwrap.f90 params.f90
	$(FPY) -m main -c $^ $(F2PYFLAGS) $(LIBS)


covmat: covmat_dump.f90
	$(FC) -o covmat $(FFLAGS) $^





clean: 
	rm -f gaussian *.so *.o *.mod $(MN_OBJ) 

cleanall:
	rm -f gaussian *.so *.o *.mod $(MN_OBJ) chains/*

cleanchains:
	rm -f chains/*