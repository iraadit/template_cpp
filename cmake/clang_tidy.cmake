# find clang-tidy
find_program(CLANG_TIDY_PATH
	NAMES clang-tidy clang-tidy-6.0 clang-tidy-5.0
	DOC "Path to clang-tidy."
)

# error if not found
if(NOT CLANG_TIDY_PATH)
	message(FATAL_ERROR "Could not find clang-tidy.")
endif()
message(STATUS "Path to clang-tidy: ${CLANG_TIDY_PATH}")

# set clang-tidy options, support WERROR
set(OPT "${CLANG_TIDY_PATH}")
if(WERROR)
	set(OPT "${OPT};-warnings-as-errors=*")
endif()

# set default properties for all new targets
set(CMAKE_C_CLANG_TIDY "${OPT}" CACHE STRING
	"Clang-tidy options for C." FORCE)
set(CMAKE_CXX_CLANG_TIDY "${OPT}" CACHE STRING
	"Clang-tidy options for C++." FORCE)
