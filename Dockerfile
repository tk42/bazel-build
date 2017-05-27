FROM ubuntu:16.04
FROM python:slim
MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

# Preinstall
RUN apt-get autoclean && apt-get update && apt-get upgrade -y && \
    apt-get install -y -q wget curl git gcc build-essential && \

# Install Python
    pip3 install -U pip && \

# Install dependencies of Bazel
    apt-get install -y pkg-config zip g++ zlib1g-dev unzip && \
    rm -rf /var/lib/apt/lists/* && \

# fix the bazel building sandbox issue by disable sandboxing
    echo "startup --batch" >>/tmp/bazelrc &&\
    echo "build --spawn_strategy=standalone --genrule_strategy=standalone" >>/tmp/bazelrc && \

# build bazel from src (tag: 0.5.0 from https://github.com/bazelbuild/bazel/releases)
    git clone https://github.com/google/bazel.git /bazel && cd /bazel && git checkout 0.5.0 &&\
        BAZELRC=/tmp/bazelrc /bazel/compile.sh && \

ENV PATH $PATH:/bazel/output/

# config the bazel command complete
RUN cd /bazel && \
    bazel --bazelrc=/tmp/bazelrc build //scripts:bazel-complete.bash && \
    cp bazel-bin/scripts/bazel-complete.bash /etc/bash_completion.d && \

# create bazelrc
    cd ~ && \
    echo "build:arm --crosstool_top=//tools:toolchain --cpu=armeabi-v7a" >>.bazelrc && \
    echo "build:i686 --crosstool_top=//tools:toolchain --cpu=i686" >>.bazelrc && \
    echo "build:x86_64 --crosstool_top=//tools:toolchain --cpu=x86_64" >>.bazelrc && \

# run bazel to avoid "Extracting Bazel installation..."
    bazel