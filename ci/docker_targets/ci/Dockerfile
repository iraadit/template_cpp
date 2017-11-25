FROM debian:testing

RUN apt-get update \
	&& apt-get install -y cppcheck cmake gcc g++ clang \
		libfindbin-libs-perl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
