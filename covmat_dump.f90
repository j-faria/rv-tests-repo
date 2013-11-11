program cov_mat

	implicit none
	integer, parameter :: dim = 179
	real(kind=8), dimension(dim) :: times, rvs, errors
	integer, dimension(dim) :: observ
	real(kind=8), dimension(dim,dim) :: covmat
	real(kind=8), dimension(dim) :: alpha, tau
	integer :: i

	!load data
	open(unit=15, file='14her.rv', status="old")
	do i = 1, 119
        read(15, *) times(i), rvs(i), errors(i)
    end do
    close(15)

    open(unit=15, file='14her2.rv', status="old")
	do i = 120, 179
        read(15, *) times(i), rvs(i), errors(i)
    end do
    close(15)

    covmat = 0.d0
    observ(1:119) = 1
    observ(120:179) = 2
    write(*,*) observ

    alpha(1:119) = 1.d0
    alpha(120:179) = 0.5d0

    tau(1:119) = 1.d0
    tau(120:179) = 1.d0

    call calc_covmat(times, rvs, errors, observ, alpha, tau, covmat)
!     write(*,'(10e12.2)') covmat


contains

	subroutine calc_covmat(times, vec, sigma, observ, alpha, tau, covmat)
	! Calculate the covariance matrix of the observations
		! vectors with times, rvs and uncertainties
		real(kind=8), intent(in), dimension(:) :: times, vec, sigma
		! vector with flags for points comming from each observatory
		integer, intent(in), dimension(:) :: observ
		! nuisance parameters for each observatory
		real(kind=8), intent(in), dimension(:) :: alpha, tau
		! on output, the covariance matrix of the observations
		real(kind=8), intent(inout), dimension(:,:) :: covmat

		! local variables
		integer :: i, j, nt

		covmat = 0.d0
		nt = size(vec)
		do i=1,nt
			do j=1,nt
				! Kronecker delta on the times
				if (i==j) covmat(i,j) = (sigma(j)/alpha(j))**2
				! Kronecker delta on the observatories
				if (observ(i)==observ(j)) then
					covmat(i,j) = covmat(i,j) + exp(-abs(times(i)-times(j))/tau(j))
				endif
			end do
		end do
		
	end subroutine calc_covmat

end program cov_mat