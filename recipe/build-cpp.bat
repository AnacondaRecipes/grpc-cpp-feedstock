@echo on

:: cmd
echo "Building %PKG_NAME%."

set "CFLAGS=%CFLAGS% /permissive-"
set "CXXFLAGS=%CXXFLAGS% /permissive-"

echo %CFLAGS%
echo %CXXFLAGS%

mkdir build-cpp
cd build-cpp
if errorlevel 1 exit 1

cmake ..  ^
      -GNinja ^
      -DBUILD_SHARED_LIBS=ON ^
      -DCMAKE_CXX_STANDARD=17 ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH=%CONDA_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
      -DProtobuf_PROTOC_EXECUTABLE=%LIBRARY_BIN%\protoc.exe ^
      -DgRPC_ABSL_PROVIDER="package" ^
      -DgRPC_CARES_PROVIDER="package" ^
      -DgRPC_GFLAGS_PROVIDER="package" ^
      -DgRPC_PROTOBUF_PROVIDER="package" ^
      -DgRPC_SSL_PROVIDER="package" ^
      -DgRPC_RE2_PROVIDER="package" ^
      -DgRPC_ZLIB_PROVIDER="package" ^
      -DCMAKE_VERBOSE_MAKEFILE=ON
if errorlevel 1 exit 1

:: Build.
echo "Building..."
ninja -j%CPU_COUNT%
if errorlevel 1 exit /b 1

:: Install.
echo "Installing..."
ninja install
if errorlevel 1 exit /b 1


:: Error free exit.
echo "Error free exit!"
exit 0