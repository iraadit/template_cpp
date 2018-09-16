set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER x86_64-apple-darwin15-clang)
set(CMAKE_CXX_COMPILER x86_64-apple-darwin15-clang++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_AR "x86_64-apple-darwin15-ar" CACHE FILEPATH "ar")
set(CMAKE_RANLIB "x86_64-apple-darwin15-ranlib" CACHE FILEPATH "ranlib")
set(CMAKE_INSTALL_NAME_TOOL "x86_64-apple-darwin15-install_name_tool"
	CACHE FILEPATH "install_name_tool")