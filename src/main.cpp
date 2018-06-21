#include <cpp_template/derived.hpp>
#include <cpp_template/version.hpp>

#include <cstdlib>
#include <iostream>

int main(int argc, char **argv)
{
	std::cout << "argc: " << argc << '\n';
	for (int i = 0; i < argc; ++i) {
		std::cout << "argv[" << i << "]: ";
		// clang-tidy: avoid pointer arithmetic in c++
		std::cout << argv[i]; // NOLINT
		std::cout << '\n';
	}
	std::cout << std::flush;

	::derived der;
	der.init();

	std::cout << "project info:\n"
		  << "\tname: " << CPP_TEMPLATE_NAME << '\n'
		  << "\tdesc: " << CPP_TEMPLATE_DESCRIPTION << '\n'
		  << "\tauthor: " << CPP_TEMPLATE_AUTHOR << '\n'
		  << "\tversion: " << CPP_TEMPLATE_VERSION << '\n'
		  << "\tmail: " << CPP_TEMPLATE_MAIL << '\n'
		  << "\tcopyright: " << CPP_TEMPLATE_COPYRIGHT << std::endl;

	return EXIT_SUCCESS;
}
