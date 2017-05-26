FROM ubuntu:16.04
MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.save && \
    mv sources.list /etc/apt/sources.list && \

# Install dependencies of Bazel
    apt-get update && \
    apt-get install -y curl git && \
    apt-get install -y pkg-config zip g++ zlib1g-dev unzip && \
    rm -rf /var/lib/apt/lists/* && \

# Install Bazel
    curl -L \
    https://github.com/bazelbuild/bazel/releases/download/0.5.0/bazel-0.5.0-installer-linux-x86_64.sh \
    -o bazel-install.sh && \
    chmod 700 bazel-install.sh && \
    ./bazel-install.sh --user && \
    rm bazel-install.sh && \

# we use this to avoid using --privileged flag
    echo "startup --batch\nbuild --spawn_strategy=standalone --genrule_strategy=standalone" > /root/.bazelrc && \

# run bazel to avoid "Extracting Bazel installation..."
    /root/bin/bazel && \

# Install Python
    apt-get install -y python && \
    apt-get install -y python-pip python-dev && \
    pip install --upgrade pip