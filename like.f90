module like

	use params
	implicit none
      
contains
      

	subroutine slikelihood(Cube,slhood)
	! Likelihood subroutine
	! This is called by getLogLike in nestwrap.f90 which does the 
	! parameter rescaling. 
	! Cube(1:nPar) has already physical parameters. The log-likelihood
	! is  returned in slhood
		implicit none
	      
		real(kind=8) :: Cube(nest_nPar), slhood
		real(kind=8) :: TwoPi
		integer :: i
	         
		TwoPi = 6.2831853d0

		slhood = - sdim / 2d0 * log( TwoPi )
		do i = 1, sdim
			slhood = slhood - log( sigma(i) )
		enddo
		
		slhood = slhood - sum( ( ( Cube( 1:sdim ) - center ) / sigma( 1:sdim ) ) ** 2d0 ) / 2d0

	end subroutine slikelihood
      

end module like
