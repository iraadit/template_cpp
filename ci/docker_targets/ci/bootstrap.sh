#!/bin/sh

set -e

apt-get update

apt-get install -y \
	cmake \
	gcc \
	g++ \
	clang-6.0 \
	clang-tidy-6.0 \
	clang-format-6.0 \
	cppcheck

rm -rf /var/lib/apt/lists/*
