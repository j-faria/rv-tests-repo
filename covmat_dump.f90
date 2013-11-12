program cov_mat

	use lib_matrix, only: determinant, inverse

	implicit none
	real(kind=8), parameter :: pi = 3.1415926535897932384626433832795029d0
	real(kind=8), parameter :: twopi = 2.d0 * pi
	integer, parameter :: dim = 10!179
	real(kind=8), dimension(dim) :: times, rvs, errors
	integer, dimension(dim) :: observ
	real(kind=8), dimension(dim,dim) :: covmat, inv_covmat
	real(kind=8), dimension(dim) :: alpha, tau
	integer :: i

	!load data
	open(unit=15, file='14her.rv', status="old")
	do i = 1, 5!119
        read(15, *) times(i), rvs(i), errors(i)
    end do
    close(15)

    open(unit=15, file='14her2.rv', status="old")
	do i = 6,10!120, 179
        read(15, *) times(i), rvs(i), errors(i)
    end do
    close(15)

    covmat = 0.d0
    observ(1:5) = 1 !(1:119)
    observ(6:10) = 2 !(120:179)
!     write(*,*) observ

    alpha(1:5) = 1.d0!(1:119)
    alpha(6:10) = 0.5d0!(120:179)

    tau(1:5) = 1.d0!(1:119)
    tau(6:10) = 1.d0!(120:179)

    call calc_covmat(times, errors, observ, alpha, tau, covmat)
    write(*,'(10e13.5)') covmat
    print *, sqrt(twopi*determinant(covmat))
	call inverse(covmat, inv_covmat)
	write(*,'(10e12.2)') inv_covmat


contains

	subroutine calc_covmat(times, sigma, observ, alpha, tau, covmat)
	! Calculate the covariance matrix of the observations
		! vectors with times, rvs and uncertainties
		real(kind=8), intent(in), dimension(:) :: times, sigma
		! vector with flags for points comming from each observatory
		integer, intent(in), dimension(:) :: observ
		! nuisance parameters for each observatory
		real(kind=8), intent(in), dimension(:) :: alpha, tau
		! on output, the covariance matrix of the observations
		real(kind=8), intent(inout), dimension(:,:) :: covmat

		! local variables
		integer :: i, j, nt

		covmat = 0.d0
		nt = size(sigma)
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