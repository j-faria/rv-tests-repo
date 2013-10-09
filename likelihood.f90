!*  Purpose
!*  =======
!*  Currently just a wrapper aroung get_rv for testing
subroutine test_wrapper(time, P, K, ecc, omega, t0, vsys, vel, nt, np)
    implicit none

!f2py intent(in) time(nt)
!f2py intent(inout) vel(nt)
!f2py intent(in) P(np)
!f2py intent(in) K(np)
!f2py intent(in) ecc(np)
!f2py intent(in) omega(np)
!f2py intent(in) t0(np)
!f2py intent(in) vsys
!f2py intent(hide) nt
!f2py intent(hide) np

! Input arguments
    integer nt, np ! number of observations, planets
    real (kind=8), dimension(nt) :: time, vel
    real (kind=8), dimension(np) :: p, k, ecc, omega, t0
    real (kind=8) :: vsys


    call get_rvN(time, P, K, ecc, omega, t0, vsys, vel, nt, np)

end subroutine