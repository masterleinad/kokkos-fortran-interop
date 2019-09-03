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

module axpy_f_mod
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env
  
    use :: flcl_mod
  
    implicit none
  
    public
      interface
        subroutine f_kokkos_initialize() &
          bind(c, name='c_kokkos_initialize')
          use, intrinsic :: iso_c_binding
          implicit none
        end subroutine f_kokkos_initialize
      end interface

      interface
        subroutine f_kokkos_finalize() &
          bind(c, name='c_kokkos_finalize')
          use, intrinsic :: iso_c_binding
          implicit none
        end subroutine f_kokkos_finalize
      end interface

      interface
        subroutine f_axpy( nd_array_y, nd_array_x, alpha ) &
          & bind(c, name='c_axpy')
          use, intrinsic :: iso_c_binding
          use :: flcl_mod
          type(nd_array_t) :: nd_array_y
          type(nd_array_t) :: nd_array_x
          real(c_double) :: alpha
        end subroutine f_axpy
      end interface

      contains
        
        subroutine kokkos_initialize()
          use, intrinsic :: iso_c_binding
          implicit none
          call f_kokkos_initialize()
        end subroutine kokkos_initialize
        
        subroutine kokkos_finalize()
          use, intrinsic :: iso_c_binding
          implicit none
          call f_kokkos_finalize()
        end subroutine kokkos_finalize

        subroutine axpy( y, x, alpha )
          use, intrinsic :: iso_c_binding
          use :: flcl_mod
          implicit none
          real(c_double), dimension(:), intent(inout) :: y
          real(c_double), dimension(:), intent(in) :: x
          real(c_double), intent(in) :: alpha

          call f_axpy(to_nd_array(y), to_nd_array(x), alpha)

        end subroutine axpy
  
end module axpy_f_mod