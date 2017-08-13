FROM ubuntu:16.04
FROM python:3.6.2-jessie
# Install Bazel, https://bazel.build/versions/master/docs/install.html#ubuntu
FROM openjdk:8

MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

# Install Bazel 0.5.1
RUN apt-get update \
  && apt-get install -y pkg-config zip g++ zlib1g-dev unzip \
  && wget https://github.com/bazelbuild/bazel/releases/download/0.5.1/bazel-0.5.1-installer-linux-x86_64.sh \
  && chmod +x bazel-0.5.2-installer-linux-x86_64.sh \
  && ./bazel-0.5.2-installer-linux-x86_64.sh --user \

# run bazel test
  && bazel \
  && export PATH="$PATH:$HOME/bin"

# Install make
RUN apt-get update \
    && apt-get install -y make vim less

# Install python modules
RUN apt-get install -y python3-pip python3-dev \
    && pip3 install --upgrade pip

# Install other modules
RUN apt-get install -y pandoc

# Set up workspace
ENV WORKSPACE /home
WORKDIR /home