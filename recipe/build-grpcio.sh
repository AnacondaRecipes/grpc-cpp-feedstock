#!/bin/bash

export GRPC_BUILD_WITH_BORING_SSL_ASM=""
export GRPC_PYTHON_BUILD_SYSTEM_CARES="True"
export GRPC_PYTHON_BUILD_SYSTEM_ABSL="True"
export GRPC_PYTHON_BUILD_SYSTEM_GRPC_CORE="True"
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL="True"
export GRPC_PYTHON_BUILD_SYSTEM_RE2="True"
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB="True"
export GRPC_PYTHON_BUILD_WITH_CYTHON="True"
export GRPC_PYTHON_USE_PREBUILT_GRPC_CORE=""
export GRPC_RE2_LIBRARY="${PREFIX}/lib/libre2.${SHLIB_EXT}"

if [[ "${target_platform}" == linux-* ]]; then
    # set these so the default in setup.py are not used
    # it seems that we need to link to pthread on linux or osx.
    export GRPC_PYTHON_LDFLAGS="-lpthread"
    export CXXFLAGS="$CXXFLAGS -fpermissive"
elif [[ "$target_platform" == osx-* ]]; then
    export GRPC_PYTHON_LDFLAGS=" -framework CoreFoundation"
fi

ln -sf "$(which $CC)" "$SRC_DIR/cc"
export PATH="$SRC_DIR:$PATH"

$PYTHON -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -v
