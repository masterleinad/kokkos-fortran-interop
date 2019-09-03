! Copyright (c) 2019. Triad National Security, LLC. All rights reserved.
!
! This program was produced under U.S. Government contract 89233218CNA000001 for
! Los Alamos National Laboratory (LANL), which is operated by Triad National
! Security, LLC for the U.S. Department of Energy/National Nuclear Security
! Administration. All rights in the program are reserved by Triad National
! Security, LLC, and the U.S. Department of Energy/National Nuclear Security
! Administration. The Government is granted for itself and others acting on
! its behalf a nonexclusive, paid-up, irrevocable worldwide license in this
! material to reproduce, prepare derivative works, distribute copies to the
! public, perform publicly and display publicly, and to permit others to do so.
!
! This program is open source under the BSD-3 License.
!
! Redistribution and use in source and binary forms, with or without modification,
! are permitted provided that the following conditions are met:
!
! 1. Redistributions of source code must retain the above copyright
!   notice, this list of conditions and the following disclaimer.
! 2. Redistributions in binary form must reproduce the above copyright
!   notice, this list of conditions and the following disclaimer in the
!   documentation and/or other materials provided with the distribution.
! 3. Neither the name of the copyright holder nor the
!   names of its contributors may be used to endorse or promote products
!   derived from this software without specific prior written permission.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
! WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
! DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

program example_axpy
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env

  use :: flcl_mod
  use :: axpy_f_mod

  implicit none

  real(c_double), dimension(:), allocatable :: f_y
  real(c_double), dimension(:), allocatable :: c_y
  real(c_double), dimension(:), allocatable :: x
  real(c_double) :: alpha
  integer :: mm = 5000
  integer :: ii

  ! allocate memory for arrays
  write(*,*)'allocating memory'
  allocate(f_y(mm))
  allocate(c_y(mm))
  allocate(x(mm))

  ! initialize kokkos
  write(*,*)'initializing kokkos'
  call kokkos_initialize()

  ! put some random numbers in the vectors
  ! so we aren't getting optimized out of existence
  write(*,*)'setting up arrays'
  call random_seed()
  call random_number(f_y)
  do ii = 1,mm
    c_y(ii) = f_y(ii)
  end do
  call random_number(x)
  call random_number(alpha)

  ! check to see if arrays are "the same"
  if ( norm2(f_y-c_y) < (1.0e-14)*mm ) then
    write(*,*)'PASSED f_y and c_y the same before axpys'
  else
    write(*,*)'FAILED f_y and c_y the same before axpys'
  end if

  ! perform an axpy in fortran
  write(*,*)'performing an axpy in fortran'
  do ii = 1, mm
    f_y(ii) = f_y(ii) + alpha * x(ii)
  end do

  ! call the f interface to the c_axpy routine
  write(*,*)'performing an axpy with kokkos'
  call axpy(c_y, x, alpha)

  ! check to see if arrays are "the same"
  if ( norm2(f_y-c_y) < (1.0e-14)*mm ) then
    write(*,*)'PASSED f_y and c_y the same after axpys'
  else
    write(*,*)'FAILED f_y and c_y the same after axpys'
  end if

  ! finalize kokkos
  write(*,*)'finalizing kokkos'
  call kokkos_finalize()

end program example_axpy
