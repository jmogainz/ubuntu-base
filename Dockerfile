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
    zsh \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python and pip command
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && chsh -s $(which zsh)

# Copy the default .zshrc provided by Oh My Zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# Verify installations
RUN python --version && pip --version && cmake --version && gcc --version && g++ --version && ld --version

# Set the working directory
WORKDIR /workspace

# Configure Supervisor to keep the container running
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Default command to run Supervisor
CMD ["/usr/bin/supervisord"]
