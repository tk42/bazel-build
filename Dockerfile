FROM ubuntu:16.04
FROM python:3.6-slim
# Install Bazel, https://bazel.build/versions/master/docs/install.html#ubuntu
FROM openjdk:8

MAINTAINER Tadashi KOJIMA <nsplat@gmail.com>

# Install Bazel
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
  && curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

RUN apt-get update \
  && apt-get install -y bazel \
  && rm -rf /var/lib/apt/lists/* \

# run bazel test
  && bazel \

  && export PATH=$PATH:/usr/bin

# Install make
RUN apt-get update \
    && apt-get install -y make

# Install python modules
RUN apt-get install -y python3-pip python3-dev \
    && pip3 install --upgrade pip