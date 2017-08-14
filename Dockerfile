FROM ubuntu:16.04
FROM python:latest
# To install Bazel, see https://docs.bazel.build/versions/master/install-ubuntu.html#install-with-installer-ubuntu
FROM openjdk:8

MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

# Install Bazel 0.5.1 (0.5.3 has a problem related to python3)
RUN apt-get update \
  && apt-get install -y pkg-config zip g++ zlib1g-dev unzip \
  && wget https://github.com/bazelbuild/bazel/releases/download/0.5.1/bazel-0.5.1-installer-linux-x86_64.sh \
  && chmod +x ./bazel-0.5.1-installer-linux-x86_64.sh \
  && ./bazel-0.5.1-installer-linux-x86_64.sh \

# run bazel test
  && ls -l bin/ \
  && export PATH="$PATH:/root/bin" \
  && echo $PATH \
  && which bazel \
  && bazel
  && echo "export PATH=\$PATH:/root/bin" >> /root/.bash_profile \
  && echo "exec /bin/bash" >> /root/.bash_profile \
  && . /root/.bash_profile \

# Install basic commands
RUN apt-get install -y make vim less

# Install python modules
RUN apt-get install -y python3-pip python3-dev \
    && pip3 install --upgrade pip

# Install other modules
RUN apt-get install -y pandoc

# Set up workspace
ENV WORKSPACE /home
WORKDIR /home