program main

	use params
	use nestwrapper
      
	implicit none
	
	integer i
	real(kind=8), parameter :: pi = 4.0d0*atan(1.0d0)
	real(kind=8), parameter :: twopi = 2.0d0*pi

	real(kind=8), parameter :: kmax = 2129d0 ! m/s

	!no parameters to wrap around
	nest_pWrap = 0
	
	! here we set prior limits, 
	! the mathematical form is only used when rescaling

	!! Period, Jeffreys, 0.2d - 365000d
	spriorran(1,1)=0d0
	spriorran(1,2)=10d0*pi
	!! semi amplitude K, Mod. Jeffreys
	spriorran(2,1)=0d0
	! since the upper limit depends on e and P, it can only be set
	! when rescaling. We just initialize it here to 0
	spriorran(2,2)=0d0
	!! eccentricity, Uniform, 0-1
	spriorran(3,1)=0d0
	spriorran(3,2)=1d0		
	!! long. periastron, Uniform, 0-2pi rad
	spriorran(4,1)=0d0
	spriorran(4,2)=twopi		
	!! chi

	!! systematic velocity, Uniform
	!! Vmin = -Kmax, Vmax = Kmax
	spriorran(6,1)=0d0
	spriorran(6,2)=10d0*pi		


   	call nest_Sample

end program
