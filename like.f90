module like

	use params
	use utils1
	implicit none
      
contains
      

	subroutine slikelihood(Cube,slhood)
	! Likelihood subroutine
	! This is called by getLogLike in nestwrap.f90 which does the 
	! parameter rescaling. 
	! Cube(1:nPar) has already physical parameters. The log-likelihood
	! is  returned in slhood
		implicit none
	      
		real(kind=8) :: Cube(nest_nPar), slhood, vel(119)
		real(kind=8) :: TwoPi, lhood
		integer :: i
	         
		TwoPi = 6.2831853d0

		! times, rvs and errors are defined in params and initialized in main
		! Cube(1:nest_nPar) = P, K, ecc, omega, t0
 		!write(*,*) Cube(1)

		call likelihood(times, rvs, errors, &
                      Cube(1), Cube(2), Cube(3), Cube(4), Cube(5), &
                      0.d0, vel, lhood, 119, 1)

		slhood=-huge(1.d0)*epsilon(1.d0)
		slhood=logSumExp(slhood,log(lhood))
! 		slhood = log(lhood)
! 		write(*,'(f8.3)', advance='no') slhood




	end subroutine slikelihood
      

end module like
