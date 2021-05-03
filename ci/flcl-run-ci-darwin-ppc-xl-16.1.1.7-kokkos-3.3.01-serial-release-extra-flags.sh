#!/bin/tcsh
setenv CI_SEP -
setenv CI_BUILD_TYPE release
setenv CI_BUILD_SUFFIX build-extra-flags
setenv CI_INSTALL_SUFFIX install-extra-flags
setenv CI_MACHINE_ARCH ppc
setenv CI_COMPILER_FAMILY xl
setenv CI_COMPILER_VER 16.1.1.7
setenv CI_COMPILER_NAME $CI_COMPILER_FAMILY$CI_SEP$CI_COMPILER_VER$CI_SEP
setenv CI_CUDA_PREFIX cuda
setenv CI_CUDA_VER 
setenv CI_CUDA_NAME 
setenv CI_KOKKOS_PREFIX kokkos
setenv CI_KOKKOS_VER 3.3.01
setenv CI_KOKKOS_BACKEND serial
setenv CI_KOKKOS_NAME $CI_KOKKOS_PREFIX$CI_SEP$CI_KOKKOS_VER$CI_SEP$CI_KOKKOS_BACKEND$CI_SEP$CI_BUILD_TYPE
setenv CI_KOKKOS_PATH_PREFIX /home/$USER/kt
setenv CI_KOKKOS_INSTALL_DIR $CI_KOKKOS_PATH_PREFIX/$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME
setenv CI_KOKKOS_BUILD_DIR $CI_KOKKOS_INSTALL_DIR$CI_SEP$CI_BUILD_SUFFIX
setenv CI_FLCL_PREFIX flcl
setenv CI_FLCL_PATH_PREFIX /home/$USER/kokkos-fortran-interop
setenv CI_FLCL_CI_PATH_PREFIX $CI_FLCL_PATH_PREFIX/ci
setenv CI_FLCL_KOKKOS_PATH $CI_KOKKOS_INSTALL_DIR/lib64/cmake/Kokkos
setenv CI_FLCL_BUILD_DIR $CI_FLCL_CI_PATH_PREFIX/$CI_FLCL_PREFIX$CI_SEP$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME$CI_SEP$CI_BUILD_SUFFIX
setenv CI_FLCL_INSTALL_DIR $CI_FLCL_CI_PATH_PREFIX/$CI_FLCL_PREFIX$CI_SEP$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME$CI_SEP$CI_INSTALL_SUFFIX
rm -rf $CI_FLCL_INSTALL_DIR
rm -rf $CI_FLCL_BUILD_DIR
mkdir -p $CI_FLCL_INSTALL_DIR
mkdir -p $CI_FLCL_BUILD_DIR
module load cmake/3.17.3
module load ibm/xlc-16.1.1.7-xlf-16.1.1.7-gcc-9.3.0-cuda-11.0
setenv CC xlc_r
setenv CXX xlc++_r
setenv F77 xlf2008_r
setenv FC xlf2008_r
#setenv FFLAGS "-qfree=f90 -qsuffix=f=f90 -qsuffix=cpp=f90 -qextname=etime -qsuppress=1520-031 -qsuppress=1518-234:1518-317:cmpmsg -qzerosize -qlanglvl=2008std -WF,-C! -qxlf90=autodealloc -qxlf2003=polymorphic -qxlf2003=autorealloc -qxlf2003=nooldnaninf  -DXLF_COMPATIBLE=ON -qpic"
#setenv FFLAGS "-qfree=f90 -qextname=etime -qzerosize -qlanglvl=2008std -qxlf90=autodealloc -qxlf2003=polymorphic -qxlf2003=autorealloc -qxlf2003=nooldnaninf -qpic"
#setenv FFLAGS "-qfree=f90 -qextname=etime -qsuppress=1520-031 -qsuppress=1518-234:1518-317:cmpmsg -qzerosize -qlanglvl=2008std -WF,-C! -qxlf90=autodealloc -qxlf2003=polymorphic -qxlf2003=autorealloc -qxlf2003=nooldnaninf  -DXLF_COMPATIBLE=ON -qpic"
setenv VERBOSE 1
cd $CI_FLCL_BUILD_DIR
cmake $CI_FLCL_PATH_PREFIX\
    -DKokkos_DIR=$CI_FLCL_KOKKOS_PATH \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=ON \
    -DCMAKE_CXX_COMPILER_ARG1="-qxflag=disable__cplusplusOverride -F/projects/opt/ppc64le/ibm/xlc-16.1.1.7/xlC/16.1.1/etc/xlc.cfg.rhel.7.8.gcc.9.3.0.cuda.11.0" \
    -DCMAKE_Fortran_COMPILER_ARG1="-F/projects/opt/ppc64le/ibm/xlf-16.1.1.7/xlf/16.1.1/etc/xlf.cfg.rhel.7.8.gcc.9.3.0.cuda.11.0" \
    -DCMAKE_INSTALL_PREFIX=$CI_FLCL_INSTALL_DIR 
cmake --build $CI_FLCL_BUILD_DIR --parallel
cmake --install $CI_FLCL_INSTALL_DIR
#ctest
module purge
#rm -rf $CI_FLCL_BUILD_DIR