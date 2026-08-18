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

# Node.js 22.x — added via signed apt repository (no shell script execution)
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Claude Code — pinned to a specific version for reproducibility
RUN npm install -g @anthropic-ai/claude-code@2.1.234

WORKDIR /workspace

CMD ["/bin/bash"]
