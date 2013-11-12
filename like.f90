module like

	use params
	use utils1

	use lib_matrix, only: inverse, determinant
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

	subroutine get_covmat(times, sigma, observ, ss, alpha, tau, covmat, det, inv_covmat)
	! Calculates the covariance matrix of the observations and returns its 
	! determinant and inverse.
		! vectors with times and uncertainties
		real(kind=8), intent(in), dimension(:) :: times, sigma
		! vector with flags for points comming from each observatory
		integer, intent(in), dimension(:) :: observ
		! nuisance parameters for each observatory
		real(kind=8), intent(in), dimension(:) :: ss, alpha, tau
		! on output, the covariance matrix of the observations and its inverse
		real(kind=8), intent(out), dimension(:,:) :: covmat, inv_covmat
		real(kind=8), intent(out) :: det ! determinant of covmat

		! local variables
		integer :: i, j, nt

		covmat = 0.d0; inv_covmat = 0.d0
		nt = size(sigma)
		do i=1,nt
			do j=1,nt
				! Kronecker delta on the times
				if (i==j) covmat(i,j) = (sigma(j)/alpha(j))**2
				! Kronecker delta on the observatories
				if (observ(i)==observ(j)) then
					covmat(i,j) = covmat(i,j) + ss(j)**2 * exp(-abs(times(i)-times(j))/tau(j))
				endif
			end do
		end do	
		det = determinant(covmat)
		call inverse(covmat, inv_covmat)
	end subroutine get_covmat     

end module like
