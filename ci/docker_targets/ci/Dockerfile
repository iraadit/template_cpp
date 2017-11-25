FROM debian:testing

RUN apt-get update \
	&& apt-get install -y cppcheck cmake gcc g++ clang \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
