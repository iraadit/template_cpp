## Enable instrumenting code for profiling and coverage

## Make CMake behave like any decent build system ever conceived:
## When compiling foo_bar.cpp, name the object file foo_bar.o instead of the
## CMake specific and gcov-unfriendly foo_bar.cpp.o
## (https://tesxus.me/2015/09/06/cmake-and-gcov/)
set(CMAKE_CXX_OUTPUT_EXTENSION_REPLACE 1)

macro(ENABLE_INSTRUMENTATION NAME_ DESC_ )
  option(ENABLE_${NAME_} "${DESC_}")
  if(ENABLE_${NAME_})
    add_compile_options(${ARGN})
    link_libraries(${ARGN})
    set(instrumented ON)
  endif()
endmacro()

## If checking everything, also check coverage
if(AUTO_CHECK)
  add_compile_options(--coverage)
  link_libraries(--coverage)
  set(instrumented ON)
endif()

enable_instrumentation(PROFILING "Enable gprof profiling" -pg)
enable_instrumentation(COVERAGE "Enable gcov/lcov coverage reports" --coverage)
enable_instrumentation(ASAN "Enable the Address Sanitizer" -fsanitize=address)
enable_instrumentation(TSAN "Enable the Thread Sanitizer" -fsanitize=thread)
enable_instrumentation(UBSAN "Enable the Undefined Behavior Sanitizer" -fsanitize=undefined)

if(instrumented)
  ## Do not optimize when instrumenting code
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g")
  string(STRIP ${CMAKE_CXX_FLAGS} CMAKE_CXX_FLAGS)

  ## Always run the test suite
  add_custom_target(instrumented_check ALL)

  add_dependencies(instrumented_check main)
endif()

include(Coverage)