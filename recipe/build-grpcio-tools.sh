#!/bin/bash

export GRPC_PYTHON_BUILD_WITH_CYTHON=true 
rm -rf src
ln -s grpc-source/src src
cd grpc-source/tools/distrib/python/grpcio_tools
export CFLAGS="-I${SRC_DIR}/grpc-source $CFLAGS"
export CXXFLAGS="-I${SRC_DIR}/grpc-source $CXXFLAGS"
${PYTHON} -m pip install --no-deps --no-build-isolation . -vv

