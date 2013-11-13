module nestwrapper

! Nested sampling includes

use Nested
use params
use like
use priors
   
implicit none
   
contains


	subroutine nest_Sample
	! 'main' function that actually calls MultiNest
		implicit none
		
	   	integer nclusters ! total number of clusters found
		integer context
		integer maxNode ! variables used by the posterior routine
	   
	   
	   	! calling MultiNest
	   	call nestRun(nest_IS,nest_mmodal,nest_ceff,nest_nlive,nest_tol, &
	   		         nest_efr,sdim,nest_nPar, nest_nClsPar,nest_maxModes, &
	   		         nest_updInt,nest_Ztol,nest_root,nest_rseed,nest_pWrap, &
	   		         nest_fb,nest_resume,nest_outfile,nest_initMPI, &
	   		         nest_logZero,nest_maxIter,getLogLike,dumper,context)

	end subroutine nest_Sample


	subroutine getLogLike(Cube,n_dim,nPar,lnew,context)
	! Wrapper around Likelihood Function which rescales parameters
	! and then calls the actual likelihood calculations
		implicit none
		
		! Input arguments
		integer n_dim ! total number of free parameters
		integer nPar ! total number of free plus derived parameters

		!Input/Output arguments
		! on entry has the ndim parameters in unit-hypercube
		! on exit has the physical parameters plus a copy of any
		! derived parameters you want to store
		double precision Cube(nPar)
		real(kind=8) :: P, K, ecc, omega, t0
		 						
		! Output arguments
		double precision lnew ! loglikelihood
		integer context ! additional information user wants to pass
		

		! Transform parameters to physical space using assigned priors
		! Cube(1:nPar) = P, K, ecc, omega, t0
		P = UniformPrior(Cube(1), spriorran(1,1), spriorran(1,2))
		ecc = UniformPrior(Cube(3), spriorran(3,1), spriorran(3,2))
		omega = UniformPrior(Cube(4), spriorran(4,1), spriorran(4,2))
		t0 = UniformPrior(Cube(5), spriorran(5,1), spriorran(5,2))

		K = UniformPrior(Cube(2), 50d0, 100d0) ! for now

		Cube(1:nPar) = (/P, K, ecc, omega, t0/)
		!write(unit=*, fmt=*) '+++', Cube(1:nPar)

		!call loglike function here 
		call slikelihood(Cube,lnew)

	end subroutine getLogLike


	subroutine dumper(nSamples, nlive, nPar, physLive, posterior, paramConstr, maxLogLike, logZ, logZerr, context)
	! dumper routine, called after every updInt*10 iterations
	! and at the end of the sampling.
		implicit none

		integer nSamples ! number of samples in posterior array
		integer nlive ! number of live points
		integer nPar ! number of parameters saved (physical plus derived)
		! array containing the last set of live points:
		double precision, pointer :: physLive(:,:)	
		! array with the posterior distribution
		double precision, pointer :: posterior(:,:)	
		! array with mean, sigmas, maxlike & MAP parameters:
		double precision, pointer :: paramConstr(:)	
		double precision maxLogLike ! max loglikelihood value
		double precision logZ ! log evidence
		double precision logZerr ! error on log evidence
		integer context ! any additional information user wants to pass
		

		! now do something
		if (doing_debug) write(*,*) paramConstr(:)
		write(*,*) paramConstr(1:nPar)

	end subroutine dumper


end module nestwrapper
