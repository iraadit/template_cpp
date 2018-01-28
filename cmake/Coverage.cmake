## Find gcov for gcc or llvm-cov gcov for clang. For clang also write a small
## helper script so lcov can deal with it.
if(IS_ABSOLUTE $ENV{GCOV})
  set(CPPCHECK $ENV{GCOV}
    CACHE FILEPATH "Path to gcov or llvm-cov executable"
  )
else()
  if(DEFINED ENV{GCOV})
    find_program(GCOV $ENV{GCOV}
      PATHS ENV PATH    
      DOC "Path to gcov or llvm-cov executable"
      NO_DEFAULT_PATH
    )
  endif()

  string(REGEX MATCH "^[0-9]+" compiler_major_version ${CMAKE_CXX_COMPILER_VERSION})
  string(REGEX MATCH "^[0-9]+\\.[0-9]+" compiler_major_minor_version ${CMAKE_CXX_COMPILER_VERSION})
  get_filename_component(compiler_dir "${CMAKE_CXX_COMPILER}" DIRECTORY)
  if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    find_program(GCOV
      NAMES llvm-cov-${compiler_major_minor_version} llvm-cov-${compiler_major_version} llvm-cov
      HINTS "${compiler_dir}"
      DOC "Path to gcov or llvm-cov executable"
    )
  endif()
  find_program(GCOV
    NAMES gcov-${compiler_major_minor_version} gcov-${compiler_major_version} gcov
    HINTS "${compiler_dir}"
    DOC "Path to gcov or llvm-cov executable"
  )
endif()

if(GCOV)
  message(STATUS "Using gcov: " ${GCOV})
else()
  message(WARNING "Gcov NOT FOUND!")
endif()

mark_as_advanced(GCOV)

get_filename_component(gcov_dir "${GCOV}" NAME)
if(gcov_dir MATCHES "^llvm-cov")
  set(GCOV_IS_LLVM_COV TRUE
    CACHE BOOL "GCOV is actually llvm-cov and needs a wrapper to work with lcov"
  )
else()
  set(GCOV_IS_LLVM_COV FALSE
    CACHE BOOL "GCOV is actually llvm-cov and needs a wrapper to work with lcov"
  )
endif()

mark_as_advanced(GCOV_IS_LLVM_COV)

if(GCOV_IS_LLVM_COV)
  configure_file(cmake/llvm-gcov.sh.in llvm-gcov.sh)
  # execute_process(COMMAND chmod +x "${CMAKE_CURRENT_BINARY_DIR}/llvm-gcov.sh")
  set(GCOV ${CMAKE_CURRENT_BINARY_DIR}/llvm-gcov.sh)
endif()

## Find lcov
if(IS_ABSOLUTE $ENV{LCOV})
  set(LCOV $ENV{LCOV}
    CACHE FILEPATH "lcov executable path"
  )
else()
  if(DEFINED ENV{LCOV})
    find_program(LCOV $ENV{LCOV}
      PATHS ENV PATH    
      DOC "lcov executable path"
      NO_DEFAULT_PATH
    )
endif()
  find_program(LCOV lcov
    DOC "lcov executable path"
  )
endif()

mark_as_advanced(LCOV)

if(LCOV)
  message(STATUS "Using lcov: " ${LCOV})

  ## Find genhtml
  if(IS_ABSOLUTE $ENV{GENHTML})
    set(GENHTML $ENV{GENHTML}
      CACHE FILEPATH "genhtml executable path"
    )
  else()
    if(DEFINED ENV{GENHTML})
      find_program(GENHTML $ENV{GENHTML}
        PATHS ENV PATH    
        DOC "genhtml executable path"
        NO_DEFAULT_PATH
      )
    endif()
    get_filename_component(lcov_dir "${LCOV}" DIRECTORY)
    find_program(GENHTML genhtml
      HINTS ${lcov_dir}
      DOC "genhtml executable path"
    )
  endif()

  mark_as_advanced(GENHTML)

  if(GENHTML)
    message(STATUS "Using genhtml: " ${GENHTML})
  else()
    message(WARNING "genhtml NOT FOUND!")
  endif()
else()
  message(WARNING "lcov NOT FOUND!")
endif()

if(ENABLE_COVERAGE OR (AUTO_CHECK AND GCOV AND LCOV AND GENHTML))
  if(GCOV AND LCOV AND GENHTML)
    if(ALL_IMPLEMENTATION_FILES OR ALL_INLINE_IMPLEMENTATION_FILES)
      add_custom_command(OUTPUT lcov-all.info
        COMMAND ${LCOV} 
          --directory ${CMAKE_CURRENT_BINARY_DIR} 
          --gcov-tool ${GCOV}
          --capture
          --output-file lcov-all.info
        DEPENDS check
        COMMENT "Capturing coverage data"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}      
      )

      add_custom_command(OUTPUT lcov-hlr.info
        COMMAND ${LCOV} 
          --directory ${CMAKE_CURRENT_BINARY_DIR} 
          --gcov-tool ${GCOV}
          --extract lcov-all.info
            ${ALL_IMPLEMENTATION_FILES}
            ${ALL_INLINE_IMPLEMENTATION_FILES}
          --output-file lcov-hlr.info
        DEPENDS lcov-all.info
        COMMENT "Extracting source files from coverage data"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}      
      )

      add_custom_target(coverage ALL
        COMMAND /bin/sh -c '
          if [ -s lcov-hlr.info ]\; then
            ${GENHTML} 
              --title ${PROJECT_NAME}
              --show-details
              --num-spaces 4
              --demangle-cpp
              --output-directory coverage
              lcov-hlr.info\;
          else
            mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/coverage &&
            sed 
              -e \"s/@PROJECT_NAME@/${PROJECT_NAME}/g\"
              -e \"s/@CURRENT_TIME@/`LANG=C date +%Y-%m-%d\\ %H:%M:%S`/g\"
              ${CMAKE_CURRENT_SOURCE_DIR}/cmake/no-coverage.html.in
            > ${CMAKE_CURRENT_BINARY_DIR}/coverage/index.html \;
          fi'
        COMMAND ${CMAKE_COMMAND} -E remove lcov-all.info lcov-hlr.inf
        DEPENDS lcov-hlr.info
        COMMENT "Generating coverage report"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      )
    else()
      add_custom_target(coverage ALL
        COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/coverage
        COMMAND /bin/sh -c '
            sed 
              -e \"s/@PROJECT_NAME@/${PROJECT_NAME}/g\"
              -e \"s/@CURRENT_TIME@/`LANG=C date +%Y-%m-%d\\ %H:%M:%S`/g\"
              ${CMAKE_CURRENT_SOURCE_DIR}/cmake/no-coverage.html.in
            > ${CMAKE_CURRENT_BINARY_DIR}/coverage/index.html \;
          fi'
        DEPENDS lcov-hlr.info
        COMMENT "Generating coverage report"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      )
    endif()
  else()
    message(SEND_ERROR "Need gcov to collect coverage and lcov and genhtml to generate reports")
  endif()
endif()

unset(compiler_major_version)
unset(compiler_major_minor_version)
unset(gcov_dir)
unset(lcov_dir)
