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
    ca-certificates \
    git \
    wget \
    curl \
    vim \
    sudo \
    zsh \
    supervisor \
    zoxide \
    libpcre2-dev \
    bison \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python and pip command
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && chsh -s $(which zsh)

# Copy the default .zshrc provided by Oh My Zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# Download and install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py310_23.10.0-1-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && /bin/bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh

# Extract the certificate from the remote server and add it to the trusted certificates
RUN echo | openssl s_client -servername repo.torchtechnologies.com -connect repo.torchtechnologies.com:443 2>/dev/null | openssl x509 -outform PEM > /usr/local/share/ca-certificates/torchtech.crt
# Download the DigiCert certificate
RUN wget -q -O /usr/local/share/ca-certificates/DigiCertGlobalG2TLSRSASHA2562020CA1.crt https://cacerts.digicert.com/DigiCertGlobalG2TLSRSASHA2562020CA1.crt.pem

# Update CA certificates
RUN update-ca-certificates

# Configure Git to use the stored credentials, correct SSL certs, and set user details
RUN git config --global credential.helper store \
    && git config --global http.sslCAInfo /etc/ssl/certs/ca-certificates.crt \
    && git config --global http.sslVerify true \
    && git config --global user.name "Jacob Moore" \
    && git config --global user.email "jmoore2@torchtechnologies.com"

# Verify installations
RUN python --version && pip --version && cmake --version && gcc --version && g++ --version && ld --version && zsh --version \
    && git --version

# Set the working directory
WORKDIR /workspace

# Configure Supervisor to keep the container running
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

RUN echo "https://<username>:P%40ssw0rd@repo.example.com" > /root/.git-credentials

# Default command to run Supervisor
CMD ["/usr/bin/supervisord"]
