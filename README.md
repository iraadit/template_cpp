# C Template

Magical template for C projects, improves quality of life.

Released into the public domain so you don't have to bother with crediting this.
One exception: `cmake/pkg/c_template.svg` is from KDE Choqok because AppImage
requires an icon.

A list of software used can be found in this file. For absolute minimum
requirements for build steps refer to `cicd/docker_targets/*/bootstrap.sh`.

Further details and diagrams are provided in the generated sphinx/doxygen-based
html documentation:
* [Latest release tag](https://template.doc.mel.vin/c)
* [Development version](https://doc.mel.vin/template/c/review-master-sm85pj)

The official project home and all official mirrors:
* Home: https://git.mel.vin/template/c
* GitLab: https://gitlab.com/melvinvermeeren/template_c
* GitHub: https://github.com/melvinvermeeren/template_c

## Code

* a nice directory layout that is easily extended
* [clang-format](https://clang.llvm.org/docs/ClangFormat.html)
  * relieves reviewers of trashing you yet again

## Analyse

* [clang-tidy](https://clang.llvm.org/extra/clang-tidy/)
  * both in-depth analysis of code and style enforcement
* [flawfinder](https://www.dwheeler.com/flawfinder/)
  * prevent embarrassing security flaws which the GDPR will fine you for

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

## Documentation

* [Doxygen](https://www.stack.nl/~dimitri/doxygen/)
  * for technical API documentation in source code
* [Sphinx](http://www.sphinx-doc.org/en/stable/)
  * for all other documentation in wonderful reStructuredText
* [Breathe](https://github.com/michaeljones/breathe)
  * breathes in doxygen and exhales reStructuredText

## CI CD

* [GitLab CI/CD](https://docs.gitlab.com/ce/ci/)
  * integrated with the entire very well designed workflow
  * use `^ *lines\.+: (\d+\.\d+\%) \(\d+ of \d+ lines\)$` regex for CI coverage
* [docker](https://git.mel.vin/cicd/docker)
  * easy building and deployment of docker images

## Tips

* [perf](https://perf.wiki.kernel.org/index.php/Main_Page)
  * efficient profiler, requires Linux kernel
* [hotspot](https://github.com/KDAB/hotspot)
  * useful GUI for perf
* [heaptrack](https://github.com/KDE/heaptrack)
  * heap memory profiler, requires Linux kernel
* [valgrind](http://valgrind.org/)
  * still useful for undefined behaviour and data-race checking at times
* [spacevim](http://spacevim.org/)
  * the brilliant cult again creates the superior user experience
* [spacemacs](http://spacemacs.org/)
  * the evil church can never escape from their bloated foundations

*Note: The authors may have been slightly biased when this section was written.*
