@echo on

set "CFLAGS=%CFLAGS% /permissive-"
set "CXXFLAGS=%CXXFLAGS% /permissive-"

echo %CFLAGS%
echo %CXXFLAGS%

mkdir build-cpp
if errorlevel 1 exit 1

cd build-cpp
if errorlevel 1 exit 1

cmake ..  ^
      -GNinja ^
      -DCMAKE_CXX_STANDARD=17 ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH=%CONDA_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DgRPC_ABSL_PROVIDER="package" ^
      -DgRPC_CARES_PROVIDER="package" ^
      -DgRPC_GFLAGS_PROVIDER="package" ^
      -DgRPC_PROTOBUF_PROVIDER="package" ^
      -DgRPC_SSL_PROVIDER="package" ^
      -DgRPC_RE2_PROVIDER="package" ^
      -DgRPC_ZLIB_PROVIDER="package" ^
      -DCMAKE_VERBOSE_MAKEFILE=ON
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1
