# Changelog

Reverse chronologically sorted, i.e. newest on top.

View the commit history for minor fixes and improvements, only important changes
are listed below.

## 1.2.0 / unreleased

* building code is optional so there is no hard dependency on a compiler
* do not prevent mixing C and C++ compilers
* supply the regex for gitlab CI coverage in documentation
* remove ci/style/line\_limit.sh in favour of clang-format
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
