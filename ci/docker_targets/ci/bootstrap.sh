#!/bin/sh

set -e

apt-get update

apt-get install -y \
	clang-6.0 \
	clang-format-6.0 \
	clang-tidy-6.0 \
	cmake \
	cppcheck \
	doxygen \
	g++ \
	gcc \
	graphviz \
	lcov \
	python-breathe \
	python-sphinx \
	python-sphinx-rtd-theme

rm -rf /var/lib/apt/lists/*
