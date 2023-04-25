#!/bin/bash

set -ex

grpc_cpp_plugin < /dev/null

# Compile a trivial service definition to C++
if [[ "${build_platform}" == "${target_platform}" ]]; then
  protoc -I./tests/include --plugin=protoc-gen-grpc=$PREFIX/bin/grpc_cpp_plugin --grpc_out=. hello.proto
  test -f hello.grpc.pb.h
  test -f hello.grpc.pb.cc
fi
