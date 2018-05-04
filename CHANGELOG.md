# Changelog

Reverse chronologically sorted, i.e. newest on top.

View the commit history for minor fixes and improvements, only important changes
are listed below.

## 1.2.0 / unreleased

* remove cppcheck
* add flawfinder target which checks code with flawfinder
* add SANITISE flag which adds -fsanitize=address -fsanitize=undefined
* add format target that will format all sources with clang-format
* add style/regex\_check.sh to find non-ASCII characters in sources
* split docker images to make managing easier and builds more efficient
* integrate doxygen, sphinx and gitlab pages to generate complete documentation
* remove the catch submodule as it is a regular system dependency
* building code is optional so there is no hard dependency on a compiler
* do not prevent mixing C and C++ compilers
* supply the regex for gitlab CI coverage in documentation
* added support for coverage by using gcov, lcov and llvm-cov
* jobs in the analyse stage will warn instead of failing the build
* support stable clang-format which is currently 5
* add CLANG\_TIDY flag that will check on make
* add WERROR flag that will turn warnings into errors
* disable modernize-deprecated-headers which is buggy with extern C blocks

## 1.1.0 / 2017-11-27

Donald Knuth

* break before binary and ternary operators

## 1.0.0 / 2017-11-26

One and a half year in the making!

* directory layout
* formatting with clang-format
* analyse with clang-tidy, cppcheck
* build with cmake, gcc, clang
* test with Catch2
* CI CD with docker, style
