# C/C++ Template

Magical template for C/C++ projects, improves quality of life.

Released into the public domain so you don't have to bother with crediting this.

## Code

* a nice directory layout that is easily extended
* [clang-format](https://clang.llvm.org/docs/ClangFormat.html)
  * relieves reviewers of trashing you yet again

## Analyse

* [clang-tidy](https://clang.llvm.org/extra/clang-tidy/)
  * both in-depth analysis of code and style enforcement
* [cppcheck](http://cppcheck.sourceforge.net/)
  * bug and undefined behaviour hunting device

## Build

* [cmake](https://cmake.org/)
  * simplified complicated build system
* [gcc](https://gcc.gnu.org/)
  * blessed, holy grail C/C++ compiler
* [clang](https://clang.llvm.org/)
  * fruity C/C++ compiler for when GPLv3 scares you

## Test

* [Catch2](https://github.com/catchorg/Catch2)
  * easy-to-use header-only unit testing framework
* [gcov](https://gcc.gnu.org/onlinedocs/gcc/Gcov.html)
  * instrument code for coverage, with freedom
* [llvm-cov](https://llvm.org/docs/CommandGuide/llvm-cov.html)
  * like gcov, but with less enforced freedom
* [lcov](http://ltp.sourceforge.net/coverage/lcov.php)
  * generate beautiful html-based coverage reports
  * Use `^ *lines\.+: (\d+\.\d+\%) \(\d+ of \d+ lines\)$` regex for CI coverage

## CI CD

* [docker](https://git.mel.vin/cicd/docker)
  * easy building and deployment of docker images
* [style](https://git.mel.vin/cicd/style)
  * 80-char line limit enforcement

## Tips

* [vim](https://git.mel.vin/conf/vim)
  * comfy config that neatly integrates into this template
