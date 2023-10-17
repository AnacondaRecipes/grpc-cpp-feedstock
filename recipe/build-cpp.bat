@echo on

@rem The `vs2015_win-64` compiler activate package sets CFLAGS and CXXFLAGS
@rem to "-MD -GL".  Unfortunately that causes a huge ballooning in static
@rem library size (more than 100MB per .lib file).  Unsetting those flags
@rem simply works.

set "CFLAGS="
set "CXXFLAGS="
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
      -DBUILD_SHARED_LIBS=ON ^
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
