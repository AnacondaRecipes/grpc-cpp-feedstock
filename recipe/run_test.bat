@echo on

grpc_cpp_plugin < NUL

@rem Compile a trivial service definition to C++

protoc -Itests/include --plugin=protoc-gen-grpc=%LIBRARY_PREFIX%/bin/grpc_cpp_plugin.exe --grpc_out=. hello.proto || exit /B

if errorlevel 1 exit 1

if not exist hello.grpc.pb.h exit 1
if not exist hello.grpc.pb.cc exit 1
if not exist %PREFIX%\\Library\\lib\\address_sorting%LIB_EXT% exit 1
if not exist %PREFIX%\\Library\\lib\\gpr%LIB_EXT% exit 1
if not exist %PREFIX%\\Library\\lib\\grpc%LIB_EXT% exit 1
if not exist %PREFIX%\\Library\\lib\\grpc++%LIB_EXT% exit 1
