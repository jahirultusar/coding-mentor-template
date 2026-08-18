FROM ubuntu:24.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Base tools + Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    build-essential \
    vim \
    less \
    jq \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Common Python tooling (test runner, linter, formatter)
RUN pip3 install --break-system-packages --no-cache-dir \
    pytest \
    ruff \
    black \
    ipython

WORKDIR /workspace

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
