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
    && rm -rf /var/lib/apt/lists/*

# Common Python tooling (test runner, linter, formatter)
RUN pip3 install --break-system-packages --no-cache-dir \
    pytest \
    ruff \
    black \
    ipython

# Claude Code (native installer, no Node.js required)
RUN curl -fsSL https://claude.ai/install.sh | bash \
    && cp /root/.local/bin/claude /usr/local/bin/claude \
    && chmod 755 /usr/local/bin/claude

WORKDIR /workspace

CMD ["/bin/bash"]
