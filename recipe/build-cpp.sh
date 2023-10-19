#!/bin/bash

set -ex

if [[ "${target_platform}" == osx* ]]; then
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CXX_STANDARD=14"

    # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
else
    # In Linux, absl-cpp is built on all platforms with C++17's features
    # enabled.  Specifically, absl::string_view is a typedef/alias of
    # std::string_view. Calling a function that uses absl::string_view
    # when the standard is below C++17 will result in a link time error
    # (undefined reference).
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CXX_STANDARD=17"
fi

if [[ "${target_platform}" == osx-* ]]; then
    # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

mkdir -p build-cpp
pushd build-cpp

if [[ $target_platform == osx-* ]]; then
    ln -s $BUILD_PREFIX/bin/${HOST}-ar ${HOST}-ar
    ln -s $BUILD_PREFIX/bin/${HOST}-ranlib ${HOST}-ranlib
fi
cmake ${CMAKE_ARGS} ..  \
    -GNinja \
    -DBUILD_SHARED_LIBS=ON \
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

# Build.
echo "Building..."
ninja -j${CPU_COUNT} || exit 1

# Installing
echo "Installing..."
ninja install || exit 1

popd

# These are in conflict with the re2 package.
rm -rf ${PREFIX}/include/re2
rm -rf ${PREFIX}/lib/libre2.a
rm -rf ${PREFIX}/lib/pkgconfig/re2.pc

# Error free exit!
echo "Error free exit!"
exit 0
