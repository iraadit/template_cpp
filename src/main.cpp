#include <cpp_template/derived.hpp>

#include <cstdlib>
#include <iostream>

int main(int argc, char **argv)
{
	std::cout << "argc: " << argc << '\n';
	for (int i = 0; i < argc; ++i) {
		std::cout << "argv[" << i << "]: ";
		// clang-tidy: avoid pointer arthritic in c++
		std::cout << argv[i]; // NOLINT
		std::cout << '\n';
	}
	std::cout << std::flush;

	::derived der;
	der.init();

	return EXIT_SUCCESS;
}
