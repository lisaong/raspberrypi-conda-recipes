#!/usr/bin/env bash

set +x
SHLIB_EXT=.so

curl -L -O "https://github.com/opencv/opencv_contrib/archive/$PKG_VERSION.tar.gz"
tar -zxf $PKG_VERSION.tar.gz

if [ $PY3K -eq 1 ]; then
    PY_MAJOR=3
    PY_UNSET_MAJOR=2
    LIB_PYTHON="${PREFIX}/lib/libpython${PY_VER}m${SHLIB_EXT}"
    INC_PYTHON="$PREFIX/include/python${PY_VER}m"
else
    PY_MAJOR=2
    PY_UNSET_MAJOR=3
    LIB_PYTHON="${PREFIX}/lib/libpython${PY_VER}${SHLIB_EXT}"
    INC_PYTHON="$PREFIX/include/python${PY_VER}"
fi


PYTHON_SET_FLAG="-DBUILD_opencv_python${PY_MAJOR}=1"
PYTHON_SET_EXE="-DPYTHON${PY_MAJOR}_EXECUTABLE=${PYTHON}"
PYTHON_SET_INC="-DPYTHON${PY_MAJOR}_INCLUDE_DIR=${INC_PYTHON} "
PYTHON_SET_NUMPY="-DPYTHON${PY_MAJOR}_NUMPY_INCLUDE_DIRS=${SP_DIR}/numpy/core/include"
PYTHON_SET_LIB="-DPYTHON${PY_MAJOR}_LIBRARY=${LIB_PYTHON}"
PYTHON_SET_SP="-DPYTHON${PY_MAJOR}_PACKAGES_PATH=${SP_DIR}"

PYTHON_UNSET_FLAG="-DBUILD_opencv_python${PY_UNSET_MAJOR}=0"
PYTHON_UNSET_EXE="-DPYTHON${PY_UNSET_MAJOR}_EXECUTABLE="
PYTHON_UNSET_INC="-DPYTHON${PY_UNSET_MAJOR}_INCLUDE_DIR="
PYTHON_UNSET_NUMPY="-DPYTHON${PY_UNSET_MAJOR}_NUMPY_INCLUDE_DIRS="
PYTHON_UNSET_LIB="-DPYTHON${PY_UNSET_MAJOR}_LIBRARY="
PYTHON_UNSET_SP="-DPYTHON${PY_UNSET_MAJOR}_PACKAGES_PATH="

# FFMPEG building requires pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig

mkdir -p build
cd build

cmake .. -LAH                                                             \
    -DBUILD_TESTS=0                                                       \
    -DBUILD_DOCS=0                                                        \
    -DBUILD_PERF_TESTS=0                                                  \
    -DBUILD_ZLIB=0                                                        \
    -DOPENCV_EXTRA_MODULES_PATH="../opencv_contrib-$PKG_VERSION/modules"  \
    -DTIFF_INCLUDE_DIR=$PREFIX/include                                    \
    -DTIFF_LIBRARY=$PREFIX/lib/libtiff$SHLIB_EXT                          \
    -DZLIB_LIBRARY_RELEASE=$PREFIX/lib/libz$SHLIB_EXT                     \
    -DZLIB_INCLUDE_DIR=$PREFIX/include                                    \
    -DBUILD_TIFF=0                                                        \
    -DBUILD_PNG=0                                                         \
    -DBUILD_JASPER=0                                                      \
    -DBUILD_JPEG=0                                                        \
    -DWITH_CUDA=0                                                         \
    -DWITH_OPENCL=0                                                       \
    -DWITH_OPENNI=0                                                       \
    -DWITH_MATLAB=0                                                       \
    -DWITH_VTK=0                                                          \
    -DWITH_GPHOTO2=0                                                      \
    -DWITH_LAPACK=0                                                       \
    -DINSTALL_C_EXAMPLES=0                                                \
    -DCMAKE_BUILD_TYPE="Release"                                          \
    -DCMAKE_SKIP_RPATH:bool=ON                                            \
    -DCMAKE_INSTALL_PREFIX=$PREFIX                                        \
    -DPYTHON_PACKAGES_PATH=${SP_DIR}                                      \
    -DPYTHON_EXECUTABLE=${PYTHON}                                         \
    -DPYTHON_INCLUDE_DIR=${INC_PYTHON}                                    \
    -DPYTHON_LIBRARY=${LIB_PYTHON}                                        \
    $PYTHON_SET_FLAG                                                      \
    $PYTHON_SET_EXE                                                       \
    $PYTHON_SET_INC                                                       \
    $PYTHON_SET_NUMPY                                                     \
    $PYTHON_SET_LIB                                                       \
    $PYTHON_SET_SP                                                        \
    $PYTHON_UNSET_FLAG                                                    \
    $PYTHON_UNSET_EXE                                                     \
    $PYTHON_UNSET_INC                                                     \
    $PYTHON_UNSET_NUMPY                                                   \
    $PYTHON_UNSET_LIB                                                     \
    $PYTHON_UNSET_SP

make -j2
make install
