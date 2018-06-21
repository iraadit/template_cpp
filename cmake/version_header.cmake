# add c++ header which contains project info
configure_file(
	"${CMAKE_SOURCE_DIR}/cmake/version.hpp.in"
	"${CMAKE_SOURCE_DIR}/include/${PROJECT_NAME}/version.hpp")
