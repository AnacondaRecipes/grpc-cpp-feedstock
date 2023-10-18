#!/bin/bash

set -ex

grpc_cpp_plugin < /dev/null

# Compile a trivial service definition to C++
if [[ "${build_platform}" == "${target_platform}" ]]; then
  protoc -I./tests/include --plugin=protoc-gen-grpc=$PREFIX/bin/grpc_cpp_plugin --grpc_out=. hello.proto
  test -f hello.grpc.pb.h
  test -f hello.grpc.pb.cc
fi

# Define variables and arrays
core_version="26.0.0"
core_libs=("gpr" "grpc" "grpc_unsecure")
core_cpp_libs=("grpc++" "grpc++_unsecure")
vendored_libs=("address_sorting" "upb")
binaries_plugin_langs=("cpp" "csharp" "node" "objective_c" "php" "python" "ruby")

# libraries
for each_lib in "${core_libs[@]}" "${core_cpp_libs[@]}" "${vendored_libs[@]}"; do
    # presence of shared libs (unix)
    if [ -f "$PREFIX/lib/lib${each_lib}.so" ]; then
        echo "[linux] - File $PREFIX/lib/lib${each_lib}.so found"
    else
        echo "[linux] - File $PREFIX/lib/lib${each_lib}.so not found"
    fi

    if [ -f "$PREFIX/lib/lib${each_lib}.dylib" ]; then
        echo "[osx] - File $PREFIX/lib/lib${each_lib}.dylib found"
    else
        echo "[osx] - File $PREFIX/lib/lib${each_lib}.dylib not found"
    fi

    # absence of static libs (unix)
    if [ ! -f "$PREFIX/lib/lib${each_lib}.a" ]; then
        echo "[unix] - Static library $PREFIX/lib/lib${each_lib}.a not found"
    fi

    # static libs on windows
    if [ ! -e "$LIBRARY_LIB/${each_lib}.lib" ]; then
        echo "[win] - File $LIBRARY_LIB/${each_lib}.lib not found"
        exit 1
    fi
done

# binaries
for each_lang in "${binaries_plugin_langs[@]}"; do
    if [ -f "$PREFIX/bin/grpc_${each_lang}_plugin" ]; then
        echo "[unix] - File $PREFIX/bin/grpc_${each_lang}_plugin found"
    fi

    if [ ! -e "$LIBRARY_BIN/grpc_${each_lang}_plugin.exe" ]; then
        echo "[win] - File $LIBRARY_BIN/grpc_${each_lang}_plugin.exe not found"
        exit 1
    fi
done

# pkg-config (no metadata for vendored libs)
# should work on windows in principle, but our openssl builds don't have a .pc file
for each_lib in "${core_libs[@]}"; do
    pkg-config --print-errors --exact-version "$core_version" "$each_lib" && echo "[unix] - pkg-config for $each_lib successful" || echo "[unix] - pkg-config for $each_lib failed"
done

for each_lib in "${core_cpp_libs[@]}"; do
    pkg-config --print-errors --exact-version "$core_version" "$each_lib" && echo "[unix] - pkg-config for $each_lib successful" || echo "[unix] - pkg-config for $each_lib failed"
done
