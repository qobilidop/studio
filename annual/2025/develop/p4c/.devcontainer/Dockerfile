# https://hub.docker.com/_/ubuntu
FROM ubuntu:20.04

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install common packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    gpg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install common packages for Python development
RUN apt-get update && apt-get install -y --no-install-recommends \
    python-is-python3 \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install common packages for C++ development
RUN apt-get update && apt-get install -y --no-install-recommends \
    ccache \
    clang \
    clangd \
    cmake \
    lld \
    ninja-build \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install additional P4C dependencies
# https://github.com/p4lang/p4c/blob/main/README.md#ubuntu-dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bison \
    flex \
    libfl-dev \
    libboost-dev \
    libboost-iostreams-dev \
    && rm -rf /var/lib/apt/lists/*
