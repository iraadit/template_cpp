find_path(CATCH_INCLUDE_DIR
	NAMES catch2/catch.hpp
	DOC "Path to Catch as in <catch2/catch.hpp>.")

if(NOT CATCH_INCLUDE_DIR)
	message(FATAL_ERROR "Could not find Catch.")
endif()
message(STATUS "Found Catch include dir: ${CATCH_INCLUDE_DIR}")
