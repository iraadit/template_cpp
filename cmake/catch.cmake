# find catch
find_path(CATCH_INCLUDE_DIR
	NAMES catch/catch.hpp
	DOC "Path to Catch as in <catch/catch.hpp>.")

# error if not found
if(NOT CATCH_INCLUDE_DIR)
	message(FATAL_ERROR "Could not find Catch.")
endif()
