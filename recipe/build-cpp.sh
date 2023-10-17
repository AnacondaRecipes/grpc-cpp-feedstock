#!/bin/bash

set -ex

export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CXX_STANDARD=17"

mkdir -p build-cpp
pushd build-cpp

if [[ $target_platform == osx-* ]]; then
    ln -s $BUILD_PREFIX/bin/${HOST}-ar ${HOST}-ar
    ln -s $BUILD_PREFIX/bin/${HOST}-ranlib ${HOST}-ranlib
fi
cmake ${CMAKE_ARGS} ..  \
    -DBUILD_SHARED_LIBS=ON \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DgRPC_CARES_PROVIDER="package" \
    -DgRPC_GFLAGS_PROVIDER="package" \
    -DgRPC_PROTOBUF_PROVIDER="package" \
    -DProtobuf_ROOT=$PREFIX \
    -DgRPC_SSL_PROVIDER="package" \
    -DgRPC_ZLIB_PROVIDER="package" \
    -DgRPC_ABSL_PROVIDER="package" \
    -DgRPC_RE2_PROVIDER="package" \
    -DCMAKE_AR=${AR} \
    -DCMAKE_RANLIB=${RANLIB} \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DProtobuf_PROTOC_EXECUTABLE=$BUILD_PREFIX/bin/protoc

ninja install

# These are in conflict with the re2 package.
rm -rf ${PREFIX}/include/re2
rm -rf ${PREFIX}/lib/libre2.a
rm -rf ${PREFIX}/lib/pkgconfig/re2.pc

popd
