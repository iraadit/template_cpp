#!/bin/sh

set -e

apt-get update

apt-get install -y \
	clang-6.0 \
	clang-tidy-6.0 \
	clang-format-6.0 \
	cmake \
	cppcheck \
	gcc \
	g++ \
	lcov \
	graphviz \
	python-sphinx \
	doxygen

pip install breathe

rm -rf /var/lib/apt/lists/*
