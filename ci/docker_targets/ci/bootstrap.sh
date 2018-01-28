#!/bin/sh

set -e

apt-get update

apt-get install -y \
	cppcheck \
	clang-6.0 \
	clang-tidy-6.0 \
	clang-format-6.0 \
	cmake \
	gcc \
	g++ \
	lcov

rm -rf /var/lib/apt/lists/*
