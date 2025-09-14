# -----------------------------------------------
#  Dockerfile: quay.io/gattytto/bazel-pipeline
# -----------------------------------------------
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------
#  Install system utilities and required runtimes
# -----------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        zip \
        musl-tools \
        wget \
        curl \
        gcc \
        build-essential \
        g++ \
        unzip \
        git \
        openjdk-17-jdk \
        python3 \
        python3-venv \
        python3-dev \
        ca-certificates \
        && rm -rf /var/lib/apt/lists/*

# Make /usr/bin/python3 point to Python 3.12
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# -----------------------------------------------
#  Install Go 1.22
# -----------------------------------------------
ENV GO_VERSION=1.25.0
RUN curl -fsSL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -xz -C /usr/local && \
    ln -s /usr/local/go/bin/go /usr/bin/go

# -----------------------------------------------
#  Install Bazel 6.5.0
# -----------------------------------------------
ENV BAZEL_VERSION=6.5.0
RUN curl -fsSL https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 \
      -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel

# -----------------------------------------------
#  Install Buildifier 6.4.0
# -----------------------------------------------
ENV BUILDIFIER_VERSION=6.4.0
RUN OS=$(uname -s | tr '[:upper:]' '[:lower:]') && \
    ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') && \
    curl -fsSL https://github.com/bazelbuild/buildtools/releases/download/v${BUILDIFIER_VERSION}/buildifier-${OS}-${ARCH} \
      -o /usr/local/bin/buildifier && \
    chmod +x /usr/local/bin/buildifier

# -----------------------------------------------
#  Clean‑up (remove build‑time tools)
# -----------------------------------------------
RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
