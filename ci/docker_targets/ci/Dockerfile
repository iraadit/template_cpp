FROM debian:testing

RUN apt-get update \
	&& apt-get install -y git cppcheck cmake gcc g++ clang \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
