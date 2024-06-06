# Use the official Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables to prevent some interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install basic development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gcc \
    g++ \
    binutils \
    libedit-dev \
    python3 \
    python3-pip \
    git \
    wget \
    curl \
    vim \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python and pip command
RUN ln -s /usr/bin/python3 /usr/bin/python

# Verify installations
RUN python --version && pip --version && cmake --version && gcc --version && g++ --version && ld --version

# Set the working directory
WORKDIR /workspace
